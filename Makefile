SHELL=/bin/bash

DOCKER=podman

CH_IMAGE=chromium
UUID=$(shell id -u)
GUID=$(shell id -g)

WITH_USERNS=$$(eval [ "podman" == "${DOCKER}" ] && echo "--userns=keep-id")

list:
	@ $(MAKE) -pRrq -f Makefile : 2>/dev/null \
		| grep -e "^[^[:blank:]]*:$$\|#.*recipe to execute" \
		| grep -B 1 "recipe to execute" \
		| grep -e "^[^#]*:$$" \
		| sed -e "s/\(.*\):/\1/g" \
		| sort

build:
	@ ${DOCKER} build \
		--build-arg USER_ID=${UUID} \
		--build-arg GROUP_ID=${GUID} \
		-t ${CH_IMAGE} .;

run:
	@ ${DOCKER} run \
		${WITH_USERNS} \
		--net=host -it --rm --shm-size 2g \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /dev/dri:/dev/dri \
		-v $(HOME)/.Xauthority:/home/ch/.Xauthority \
		--device /dev/video0 \
		-e DISPLAY \
		-e XAUTHORITY \
		-v ${XAUTHORITY}:${XAUTHORITY} \
		-v $(HOME)/.config/pulse/cookie:/home/ch/.config/pulse/cookie \
		-v /etc/machine-id:/etc/machine-id \
		-v /run/user/${UUID}/pulse:/run/user/${UUID}/pulse \
		-v /var/lib/dbus:/var/lib/dbus \
		--device /dev/snd \
		-e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
		-v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
		${CH_IMAGE}
