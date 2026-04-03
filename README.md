# Custom Roundcube Docker Image

This repository builds and maintains a customized version of the official `roundcube/roundcubemail` Docker image.

## Features

This custom image modifies the base Roundcube image with the following additions and fixes:

* **Server-Side Spellcheck:** Installs `aspell` along with English and German dictionaries (`aspell-en`, `aspell-de`).
* **Custom Password Driver:** Injects a custom Gandi password driver along with localization files for multiple languages (de_DE, de_CH, en_US, en_GB, en_CA, fr_FR).
* **Entrypoint Fix:** Includes a `sed` workaround in the entrypoint script to prevent a race condition between composer plugins and database initialization.
* **Silent Healthcheck Endpoint:** Implements a dedicated `/healthz` endpoint at the Apache level that bypasses the PHP interpreter and disables access logging.

## Automated Builds

The build process is fully automated via GitHub Actions (`build-push.yml`) using a robust 1:1 synchronization pipeline to ensure perfect parity with upstream releases.

* **1:1 Mirror Synchronization:** Runs every Sunday at 03:00 AM. The workflow builds images for all semantic versions (`x.x.x-apache-nonroot`) from the upstream Docker Hub
* **Smart Codebase Updates:** If changes are pushed to the `Dockerfile` or plugins, the workflow automatically triggers a rebuild of the highest patch for *every active minor release*
* **Multi-Architecture:** Builds seamlessly for both `linux/amd64` and `linux/arm64` platforms.

## Usage

You can pull the latest image directly from the GitHub Container Registry:

```yaml
services:
  roundcube:
    image: ghcr.io/Kartoffelbauer/docker-roundcube-custom:latest-nonroot
    # Rest of the configuration...
```