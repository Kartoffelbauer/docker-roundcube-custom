# Custom Roundcube Webmail 📧

This repository automatically builds and maintains a customized Docker image for Roundcube Webmail, tailored for a secure, non-root, self-hosted environment.

## ✨ Features

* **Base Image:** Built on top of the official `roundcube/roundcubemail:latest-nonroot` image.
* **Server-Side Spellcheck:** Automatically installs `aspell` along with English and German dictionaries natively into the container.
* **Gandi Integration:** Includes and configures a custom password driver for Gandi LiveDNS/Mail.
* **Zero-Touch Maintenance:** A GitHub Actions workflow automatically rebuilds and pushes the image to the GitHub Container Registry (GHCR) every Sunday to ensure the base image remains up to date.

## 🚀 Usage

You do not need to build this image locally. It is automatically published to GHCR. 

To use it in your `docker-compose.yml`, simply reference the registry:

```yaml
services:
  roundcube:
    image: ghcr.io/Kartoffelbauer/roundcube-custom:latest-nonroot
    container_name: roundcube
    restart: unless-stopped
    # Add your networks, environment variables, and volumes...
```