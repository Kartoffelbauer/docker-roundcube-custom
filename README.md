# Custom Roundcube Docker Image

This repository builds and maintains a customized version of the official `roundcube/roundcubemail:latest-nonroot` Docker image. 

## Features

This custom image modifies the base Roundcube image with the following additions and fixes:

* **Server-Side Spellcheck:** Installs `aspell` along with English and German dictionaries (`aspell-en`, `aspell-de`).
* **Custom Password Driver:** Injects a custom Gandi password driver along with localization files for multiple languages (de_DE, de_CH, en_US, en_GB, en_CA, fr_FR).
* **Entrypoint Fix:** Includes a `sed` workaround in the entrypoint script to prevent a race condition between composer plugins and database initialization.

## Automated Builds

The build process is fully automated via GitHub Actions (`build-push.yml`):
* **Smart Scheduled Builds:** Runs every Sunday at 03:00 AM. It uses `skopeo` to check the upstream Docker Hub image digest. A new build is only triggered if the official base image has actually been updated, saving resources.
* **Push Triggers:** Automatically builds if changes are made to the `Dockerfile`, configurations, or plugins.
* **Multi-Architecture:** Builds for both `linux/amd64` and `linux/arm64` platforms.
* **Registry:** Images are automatically pushed to the GitHub Container Registry (GHCR).

## Usage

You can pull the latest image directly from the GitHub Container Registry:

```yaml
services:
  roundcube:
    image: ghcr.io/Kartoffelbauer/docker-roundcube-custom:latest-nonroot
    container_name: roundcube
    restart: unless-stopped
    # Add your required ports, volumes, and environment variables here