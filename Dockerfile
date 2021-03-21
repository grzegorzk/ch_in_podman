ARG GROUP_ID=1001
ARG USER_ID=1001

FROM docker.io/techgk/arch:latest AS chromium

RUN pacman -Sy --disable-download-timeout --noconfirm \
        chromium \
        pulseaudio \
        pulseaudio-alsa \
        pulseaudio-bluetooth \
        xorg-server \
        xorg-apps \
    && rm -rf /var/cache/pacman/pkg/*

COPY docker_files/entrypoint.sh /entrypoint.sh

ARG GROUP_ID
ARG USER_ID

# Based on https://github.com/GoogleChromeLabs/lighthousebot/blob/master/builder/Dockerfile#L35-L40
RUN groupadd -g $GROUP_ID --system ch && \
    useradd --system --create-home --gid $GROUP_ID -u $USER_ID --groups audio,video ch \
    && mkdir --parents /home/ch/reports \
    && mkdir --parents /home/ch/.config \
    && mkdir --parents /home/ch/.cache \
    && chown --recursive ch:ch /home/ch \
    && chmod ugo+x /entrypoint.sh

COPY docker_files/pulse-client.conf /etc/pulse/client.conf
RUN echo "default-server = unix:/run/user/${USER_ID}/pulse/native" >> /etc/pulse/client.conf

USER ch

ENTRYPOINT ["/entrypoint.sh"]
CMD []
