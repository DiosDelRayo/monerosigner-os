LOG_PORT = 5514
DEVICE ?= pi0
BRANCH ?= master
COMMIT_ID ?= ''
APP_REPO=https://github.com/DiosDelRayo/MoneroSigner.git
BUILD_LOCAL_ARGS=
SHELL := /bin/bash
DOCKER_DEFAULT_PLATFORM ?= linux/amd64
BOARD_TYPE ?= ${DEVICE}
CURRENT_XMRSIGNER_VERSION=$(shell grep VERSION ../MoneroSigner/src/xmrsigner/controller.py | sed -E 's/^.*([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
VERSION=$(shell cat VERSION)

VIDEO_DEVICE ?= /dev/video4
VIDEO_INPUT=1
VIDEO_WIDTH=1920
VIDEO_HEIGHT=1080

# TODO: 2024-06-20, clean up the mess later, DEVICE and BOARD_TYPE, serious?

checksums:
	@echo 'generate sha256 checksums...'
	@find opt -type f -exec sha256sum --tag {} \; > SHA256
	@find tools -type f -exec sha256sum --tag {} \; >> SHA256
	@find docs -type f -exec sha256sum --tag {} \; >> SHA256
	@sha256sum --tag docker-compose.yml >> SHA256
	@sha256sum --tag Dockerfile >> SHA256
	@sha256sum --tag Makefile >> SHA256
	@sha256sum --tag README.md >> SHA256
	@sha256sum --tag LICENSE.md >> SHA256
	@sha256sum --tag VERSION >> SHA256
	@sha256sum --tag xmrsigner_dev_ssh >> SHA256
	@sha256sum --tag xmrsigner_dev_ssh.pub >> SHA256
	@sha256sum --tag xmrsigner.pub >> SHA256
	@rm -f SHA256.sig
	@git add SHA256

sign: checksums
	@echo 'Sign the checksums...'
	@tools/sign.sh
	@cat SHA256 >> SHA256.sig
	@git add SHA256.sig

verify:
	@echo 'Verify source files...'
	@signify-openbsd -C -p xmrsigner.pub -x SHA256.sig | grep -v ': OK'
	@echo 'Source is verified!'

sync-version:
	@echo ${CURRENT_XMRSIGNER_VERSION} > VERSION
	@VERSION=$(shell cat VERSION)

version: sync-version
	@git add VERSION
	@git commit -m "bump Version to ${VERSION}"
	@git tag -f "v${VERSION}"
	git push --tags -f origin master

update:
	git submodule init && git submodule update

init: update

standby:
	SS_ARGS="--no-op" docker compose up -d --no-recreate

shell:
	@docker exec -it monerosigner-os-build-images-1 bash

build:
	@echo "Building with BOARD_TYPE: $(BOARD_TYPE), DOCKER_DEFAULT_PLATFORM: $(DOCKER_DEFAULT_PLATFORM)"
	@SS_ARGS="--$(BOARD_TYPE) --app-branch=${BRANCH}"
	@export SS_ARGS
	@time docker compose up --force-recreate --build

re-create:
	@SS_ARGS="--no-op" docker compose up -d --force-recreate --build

build-commit:
	@echo "Building with BOARD_TYPE: $(BOARD_TYPE), COMMIT: $(COMMIT_ID)"
	@time SS_ARGS ?= "--$(BOARD_TYPE) --app-branch=${BRANCH} --app-repo=${APP_REPO} --app-commit-id=${COMMIT_ID} --no-clean" docker compose up --force-recreate --build

build-local-install-dependencies:
	@sudo apt update && \
		sudo apt install \
			make \
			binutils \
			build-essential \
			gcc \
			g++ \
			patch \
			gzip \
			bzip2 \
			perl \
			tar \
			cpio \
			unzip \
			rsync \
			file \
			bc \
			libssl-dev \
			dosfstools

build-local:
	@cd opt; ./build --${DEVICE} ${BUILD_LOCAL_ARGS}

update-external-packages:
	@tools/update_devices_config_in.sh

listen-for-logs:
	@echo 'Press CTRL+C to stop listening!'
	@nc -u -l 0.0.0.0 ${LOG_PORT} | tee -a listen_for_logs.txt

watch-hdmi:
	@mplayer tv:// -tv driver=v4l2:device=$(VIDEO_DEVICE):input=$(VIDEO_INPUT):width=$(VIDEO_WIDTH):height=$(VIDEO_HEIGHT)
