# Custom Roundcube Docker Image

This repository builds and maintains a customized version of the official `roundcube/roundcubemail` Docker image.

## Features

This custom image modifies the base Roundcube image with the following additions and fixes:

* **Server-Side Spellcheck:** Installs `aspell` along with English and German dictionaries (`aspell-en`, `aspell-de`).
* **Custom Password Driver:** Injects a custom Gandi password driver along with localization files for multiple languages (de_DE, de_CH, en_US, en_GB, en_CA, fr_FR).
* **Entrypoint Fix:** Includes a `sed` workaround in the entrypoint script to prevent a race condition between composer plugins and database initialization.

## Automated Builds

The build process is fully automated via GitHub Actions (`build-push.yml`) using a robust 1:1 synchronization pipeline to ensure perfect parity with upstream releases.

* **1:1 Mirror Synchronization:** Runs every Sunday at 03:00 AM. The workflow fetches all semantic versions (`x.x.x-apache-nonroot`) from upstream Docker Hub, compares them against the local GitHub Container Registry (GHCR), and dynamically queues a build matrix for any missing tags.
* **Race-Condition Free Tagging:** When building multiple versions concurrently, the pipeline safely calculates and applies the `latest-nonroot` tag strictly to the highest overall version, and binds minor tags (e.g., `1.6-nonroot`) exclusively to the highest patch in that series, preventing concurrent build jobs from overwriting active tags.
* **Smart Codebase Updates:** If changes are pushed to the `Dockerfile` or plugins, the workflow automatically triggers a rebuild of the highest patch for *every active minor release* (e.g., the latest 1.4.x, 1.5.x, and 1.6.x versions). This ensures your code changes are immediately propagated to the tags users actually rely on, without wasting resources rebuilding obsolete historical versions.
* **Manual Synchronization:** Supports execution via `workflow_dispatch`. Triggering the workflow manually forces a fresh sync check; if the repository is already fully synced, it behaves identically to a codebase update and rebuilds the active minor branches.
* **Multi-Architecture:** Builds seamlessly for both `linux/amd64` and `linux/arm64` platforms.

## Usage

You can pull the latest image directly from the GitHub Container Registry:

```yaml
services:
  roundcube:
    image: ghcr.io/Kartoffelbauer/docker-roundcube-custom:latest-nonroot
    # Rest of the configuration...