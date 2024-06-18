DEVICE=pi0
BRANCH=master
COMMIT_ID=
APP_REPO=https://github.com/DiosDelRayo/MoneroSigner.git
BUILD_LOCAL_ARGS=

update:
	git submodule init && git submodule update

init: update

standby:
	SS_ARGS="--no-op" docker compose up -d --no-recreate

shell:
	docker exec -it monerosigner-os-build-images-1 bash

build:
	docker exec -it monerosigner-os-build-images-1 "bash -c ./build.sh --${DEVICE} --app-repo=${APP_REPO} --app-branch=${BRANCH} --no-clean"

re-create:
	SS_ARGS="--no-op" docker compose up -d --force-recreate --build

build-commit:
	docker exec -it monerosigner-os-build-images-1 "bash -c ./build.sh --pi0 --app-repo=${APP_REPO} --app-commit-id=${COMMIT_ID} --no-clean"

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

build-local:
	cd opt; ./build --${DEVICE} ${BUILD_LOCAL_ARGS}

update-external-packages:
	@tools/update_devices_config_in.sh
