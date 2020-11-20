ARG GROUP_ID=1001
ARG USER_ID=1001

FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        gnupg \
        pulseaudio \
        xorg \
    && rm -rf /var/lib/apt/lists/*

COPY docker_files/entrypoint.sh /entrypoint.sh
COPY docker_files/chromium.pref /etc/apt/preferences.d/chromium.pref
COPY docker_files/debian.list /etc/apt/sources.list.d/debian.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DCC9EFBF77E11517 \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50 \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        chromium \
        chromium-sandbox \
    && rm -rf /var/lib/apt/lists/*

ARG GROUP_ID
ARG USER_ID

# Based on https://github.com/GoogleChromeLabs/lighthousebot/blob/master/builder/Dockerfile#L35-L40
RUN groupadd -g $GROUP_ID --system ch && \
    useradd --system --create-home --gid $GROUP_ID --groups audio,video ch \
    && mkdir --parents /home/ch/reports \
    && chown --recursive ch:ch /home/ch \
    && chmod ugo+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []
