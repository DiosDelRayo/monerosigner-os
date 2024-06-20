DEVICE ?= pi0
BRANCH ?= master
COMMIT_ID ?= ''
APP_REPO=https://github.com/DiosDelRayo/MoneroSigner.git
BUILD_LOCAL_ARGS=
SHELL := /bin/bash
DOCKER_DEFAULT_PLATFORM ?= linux/amd64
BOARD_TYPE ?= ${DEVICE}

#TODO: 2024-06-20, clean up the mess later, DEVICE and BOARD_TYPE, serious?

.PHONY
update:
	git submodule init && git submodule update

.PHONY
init: update

.PHONY
standby:
	SS_ARGS="--no-op" docker compose up -d --no-recreate

.PHONY
shell:
	docker exec -it monerosigner-os-build-images-1 bash

.PHONY
build:
	@echo "Building with BOARD_TYPE: $(BOARD_TYPE), DOCKER_DEFAULT_PLATFORM: $(DOCKER_DEFAULT_PLATFORM)"
	@time SS_ARGS ?= "--$(BOARD_TYPE) --app-branch=${BRANCH}" docker compose up --force-recreate --build

.PHONY
re-create:
	SS_ARGS="--no-op" docker compose up -d --force-recreate --build

.PHONY
build-commit:
	@echo "Building with BOARD_TYPE: $(BOARD_TYPE), COMMIT: $(COMMIT_ID)"
	@time SS_ARGS ?= "--$(BOARD_TYPE) --app-branch=${BRANCH} --app-repo=${APP_REPO} --app-commit-id=${COMMIT_ID} --no-clean" docker compose up --force-recreate --build

.PHONY
build-local-install-dependencies:
	sudo apt update && \
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

.PHONY
build-local:
	cd opt; ./build --${DEVICE} ${BUILD_LOCAL_ARGS}

.PHONY
update-external-packages:
	@tools/update_devices_config_in.sh
