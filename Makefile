SHELL=/bin/bash

DOCKER=podman

CH_IMAGE=chromium


list:
	@ $(MAKE) -pRrq -f Makefile : 2>/dev/null \
		| grep -e "^[^[:blank:]]*:$$\|#.*recipe to execute" \
		| grep -B 1 "recipe to execute" \
		| grep -e "^[^#]*:$$" \
		| sed -e "s/\(.*\):/\1/g" \
		| sort

build_chromium:
	${DOCKER} build \
		--build-arg USER_ID=$(shell id -u) \
		--build-arg GROUP_ID=$(shell id -g) \
		-t ${CH_IMAGE} .;

run_chromium:
	@ ${DOCKER} run \
		--net=host -it --rm --shm-size 2g \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /dev/dri:/dev/dri \
		-v $(HOME)/.Xauthority:/root/.Xauthority \
		--device /dev/video0 \
		--device /dev/dri/card0:/dev/dri/card0 \
		--security-opt=label=type:container_runtime_t \
		-e DISPLAY \
		-v $(HOME)/.config/pulse/cookie:/root/.config/pulse/cookie \
		--device /dev/snd \
		-e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
		-v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
		${CH_IMAGE}
