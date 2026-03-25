# Custom Roundcube Docker Image

This repository builds and maintains a customized version of the official `roundcube/roundcubemail` Docker image.

## Features

This custom image modifies the base Roundcube image with the following additions and fixes:

* **Server-Side Spellcheck:** Installs `aspell` along with English and German dictionaries (`aspell-en`, `aspell-de`).
* **Custom Password Driver:** Injects a custom Gandi password driver along with localization files for multiple languages (de_DE, de_CH, en_US, en_GB, en_CA, fr_FR).
* **Entrypoint Fix:** Includes a `sed` workaround in the entrypoint script to prevent a race condition between composer plugins and database initialization.

## Automated Builds

The build process is fully automated via GitHub Actions (`build-push.yml`) and is designed with strict state-aware polling to ensure no upstream releases are ever skipped.

* **State-Aware Polling:** Runs every Sunday at 03:00 AM. It fetches all semantic versions (`x.x.x-apache-nonroot`) from the upstream Docker Hub and compares them against the tags already published in this repository's GitHub Container Registry (GHCR).
* **Dynamic Matrix Builds:** If multiple new versions (or backports) have been released upstream, the workflow dynamically generates a build matrix and concurrently builds all missing versions.
* **Clean Semantic Tagging:** The workflow strictly validates base versions. When an image is built, it is automatically tagged with the patch version (`1.6.6-nonroot`), minor version (`1.6-nonroot`), and dynamically applies the `latest-nonroot` tag *only* to the absolute highest semantic version to prevent race conditions.
* **Manual Overrides:** Supports manual execution via `workflow_dispatch`. You can input a specific semantic version (e.g., `1.6.6`) or type `latest` to forcefully rebuild a specific target. Strict input validation prevents malformed builds.
* **Smart Push Triggers:** Automatically rebuilds the newest upstream tag if changes are pushed to the `Dockerfile`, configurations, or plugins to ensure code changes are deployed immediately.
* **Multi-Architecture:** Builds seamlessly for both `linux/amd64` and `linux/arm64` platforms.

## Usage

You can pull the latest image directly from the GitHub Container Registry:

```yaml
services:
  roundcube:
    image: ghcr.io/Kartoffelbauer/docker-roundcube-custom:latest-nonroot
    # Rest of the configuration...