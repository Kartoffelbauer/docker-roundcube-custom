FROM roundcube/roundcubemail:latest-nonroot

# Switch to the root user to install necessary system packages.
USER root

# Update package lists, install aspell and its language packs, then clean up.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    aspell \
    aspell-en \
    aspell-de \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy custom password driver alongside translation files into the image
COPY ./plugins/password-gandi/gandi.php /usr/src/roundcubemail/plugins/password/drivers/gandi.php
RUN chown 1000:1000 /usr/src/roundcubemail/plugins/password/drivers/gandi.php
RUN --mount=type=bind,source=./plugins/password-gandi/localization,target=/host_locales \
    cat /host_locales/de_DE.inc >> /usr/src/roundcubemail/plugins/password/localization/de_DE.inc && \
    cat /host_locales/de_CH.inc >> /usr/src/roundcubemail/plugins/password/localization/de_CH.inc && \
    cat /host_locales/en_US.inc >> /usr/src/roundcubemail/plugins/password/localization/en_US.inc && \
    cat /host_locales/en_GB.inc >> /usr/src/roundcubemail/plugins/password/localization/en_GB.inc && \
    cat /host_locales/en_CA.inc >> /usr/src/roundcubemail/plugins/password/localization/en_CA.inc && \
    cat /host_locales/fr_FR.inc >> /usr/src/roundcubemail/plugins/password/localization/fr_FR.inc

# --- Docker Race-Condition Workaround ---
# This sed command extracts the composer block into the hold space, deletes it from the original location, 
# and pastes it back right before the database initialization sequence.
RUN sed -i \
  -e '/if \[ ! -z "${ROUNDCUBEMAIL_COMPOSER_PLUGINS}" \]; then/,/if \[ ! -e config\/config.inc.php \]; then/{ /if \[ ! -e config\/config.inc.php \]; then/!{ H; d; } }' \
  -e '/# initialize or update DB/{ x; p; x; }' \
  /docker-entrypoint.sh

# Switch back to the default unprivileged user for security and portability.
USER 1000