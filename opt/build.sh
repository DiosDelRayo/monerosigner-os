#!/bin/bash

NOW=$(date +%Y-%m-%d_%H_%M)
LOG_FILE="/tmp/build-${NOW}.log"

# global variables
cur_dir_name=${PWD##*/}
cur_dir=$(pwd)
xmrsigner_app_repo="https://github.com/DiosDelRayo/MoneroSigner.git"
xmrsigner_app_repo_branch=master

help()
{
  echo "Usage: build.sh [pi board] [options]
  
  Pi Board: (only one allowed)
  -a, --all         Build for all supported pi boards
      --pi0         Build for pi0 and pi0w
      --pi02w       Build for pi02w and pi3
  
  Options:
  -h, --help           Display a help screen and quit 
      --dev            Builds developer version of images
      --log            Log build to ${LOG_FILE}
      --no-clean       Leave previous build, target, and output files
      --skip-repo      Skip pulling repo, assume rootfs-overlay/opt is populated with app code
      --app-repo       Build image with not official xmrsigner github repo
      --app-branch     Build image with repo branch other than default
      --app-commit-id  Build image with specific repo commit id
      --no-op          All other option ignored and script just hangs to keep container alive"
  exit 2
}

tail_endless() {
  echo "Running 'tail -f /dev/null' to keep script alive"
  tail -f /dev/null
  exit 0
}

download_app_repo() {
  # remove previous opt xmrsigner app repo code if it already exists
  rm -fr ${rootfs_overlay}/opt/
  
  # Download XmrSigner from GitHub and put into rootfs
  
  # check for custom app branch or custom commit. Custom commit takes priority over branch name
  if ! [ -z ${xmrsigner_app_repo_commit_id} ]; then
    echo "cloning repo ${xmrsigner_app_repo} with commit id ${xmrsigner_app_repo_commit_id}"
    git clone "${xmrsigner_app_repo}" "${rootfs_overlay}/opt/" || exit
    cd ${rootfs_overlay}/opt/
    git reset --hard "${xmrsigner_app_repo_commit_id}"
    cd -
  else
    echo "cloning repo ${xmrsigner_app_repo} with branch ${xmrsigner_app_repo_branch}"
    git clone --depth 1 -b "${xmrsigner_app_repo_branch}" "${xmrsigner_app_repo}" "${rootfs_overlay}/opt/" || exit
  fi
     
  # Delete unnecessary files to save space
  rm -rf ${rootfs_overlay}/opt/.git
  rm -rf ${rootfs_overlay}/opt/.gitignore
  rm -rf ${rootfs_overlay}/opt/*.txt
  rm -rf ${rootfs_overlay}/opt/docs
  rm -rf ${rootfs_overlay}/opt/*.md
  rm -rf ${rootfs_overlay}/opt/Makefile
  rm -rf ${rootfs_overlay}/opt/enclosures
  rm -rf ${rootfs_overlay}/opt/*.gpg
  rm -rf ${rootfs_overlay}/opt/setup.py
  rm -rf ${rootfs_overlay}/opt/tests
  rm -rf ${rootfs_overlay}/opt/tools
  rm -rf ${rootfs_overlay}/opt/pytest.ini
}

build_image() {
  # arguments: $1 - config name, $2 clean/no-clean - allows for, $3 skip-repo

  # Variables
  config_name="${1:-pi0}"
  config_dir="./${config_name}"
  rootfs_overlay="./rootfs-overlay"
  config_file="${config_dir}/configs/pi0"
  build_dir="${cur_dir}/../output"
  build2_dir="${cur_dir}/../../output"
  image_dir="${cur_dir}/../images"

  if [ ! -d "${config_dir}" ]; then
    # config does not exists
    echo "config ${config_name} not found"
    exit 1
  fi
  
  if [ "${2}" != "no-clean" ]; then
  
    # remove previous build dir
    rm -rf "${build_dir}"
    mkdir -p "${build_dir}"
    
  fi
  
  if [ "${3}" != "skip-repo" ]; then
    download_app_repo
  fi
  
  # Setup external tree
  #make BR2_EXTERNAL="../${config_dir}/" O="${build_dir}" -C ./buildroot/ #2> /dev/null > /dev/null

  make BR2_EXTERNAL="../${config_dir}/" O="${build_dir}" -C ./buildroot/ ${config_name}_defconfig
  cd "${build_dir}"
  make host-python-toml #TODO: 2024-06-26, quick fix to run the build without problems, should investigate why host-python-toml is an issue
  make
  
  # if successful, mv xmrsigner_os.img image to /images
  # rename to image to include branch name and config name, then compress
  
  VERSION=$(grep VERSION /opt/${rootfs_overlay}/opt/src/xmrsigner/controller.py | awk -F'"' '{ print $2 }')
  if [ -n "$VERSION" ]; then
	  xmrsigner_os_image_output="${image_dir}/xmrsigner_os-${VERSION}.${config_name}.img"
  else
	  xmrsigner_os_image_output="${image_dir}/xmrsigner_os-${xmrsigner_app_repo_branch}.${config_name}.img"
  fi
  if ! [ -z ${xmrsigner_app_repo_commit_id} ]; then
    # use commit id instead of branch name if it is set
    xmrsigner_os_image_output="${image_dir}/xmrsigner_os-${xmrsigner_app_repo_commit_id}.${config_name}.img"
  fi
  
  if [ -f "${build_dir}/images/xmrsigner_os.img" ] && [ -d "${image_dir}" ]; then
    mv -f "${build_dir}/images/xmrsigner_os.img" "${xmrsigner_os_image_output}"
    sha256sum "${xmrsigner_os_image_output}" > ${xmrsigner_os_image_output}.sha256sum
    sha256sum --tag "${xmrsigner_os_image_output}" > ${xmrsigner_os_image_output}.SHA256
  fi
  
  cd - > /dev/null # return to previous working directory quietly
}

###
### Gather Arguments passed into build.sh script
###

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

if [ "$VALID_ARGUMENTS" -eq 0 ]; then
  help
fi

PARAMS=""
ARCH_CNT=0
while (( "$#" )); do
  case "$1" in
  -a|--all)
    ALL_FLAG=0; ((ARCH_CNT=ARCH_CNT+1)); shift
    ;;
  -h|--help)
    HELP_FLAG=0; shift
    ;;
  --pi0)
    PI0_FLAG=0; ((ARCH_CNT=ARCH_CNT+1)); shift
    ;;
  --pi2)
    PI2_FLAG=0; ((ARCH_CNT=ARCH_CNT+1)); shift
    ;;
  --pi02w)
    PI02W_FLAG=0; ((ARCH_CNT=ARCH_CNT+1)); shift
    ;;
  --pi4)
    PI4_FLAG=0; ((ARCH_CNT=ARCH_CNT+1)); shift
    ;;
  --no-clean)
    NOCLEAN=0; shift
    ;;
  --skip-repo)
    SKIPREPO=0; shift
    ;;
  --no-op)
    NO_OP=0; shift
    ;;
  --dev)
    DEVBUILD=0; LOGBUILD=0; shift
    ;;
  --log)
    LOGBUILD=0; shift
    ;;
  --app-repo=*)
    APP_REPO=$(echo "${1}" | cut -d "=" -f2-); shift
    ;;
  --app-branch=*)
    APP_BRANCH=$(echo "${1}" | cut -d "=" -f2-); shift
    ;;
  --app-commit-id=*)
    APP_COMMITID=$(echo "${1}" | cut -d "=" -f2-); shift
    ;;
  -*|--*=) # unsupported flags
    echo "Error: Unsupported flag $1" >&2
    help
    exit 1
    ;;
  *) # unsupported flags
    echo "Error: Unsupported argument $1" >&2
    help
    exit 1
    ;;
  esac
done

# When no arguments, display help
if ! [ -z ${HELP_FLAG} ]; then
  help
fi

# Only allow 1 architecture related argument flag
if [ $ARCH_CNT -gt 1 ]; then
  echo "Invalid number of architecture arguments" >&2
  exit 3
fi

# if no-op then hang endlessly
if ! [ -z $NO_OP ]; then
  tail_endless
  exit 0
fi

# Check for --no-clean argument to pass clean/no-clean to build_image function
if [ -z $NOCLEAN ]; then
  CLEAN_ARG="clean"
else
  CLEAN_ARG="no-clean"
fi

# Check for --no-clean argument to pass clean/no-clean to build_image function
if ! [ -z $SKIPREPO ]; then
  SKIPREPO_ARG="skip-repo"
else
  SKIPREPO_ARG="no-skip-repo"
fi

echo $SKIPREPO_ARG

# Check for --dev argument to pass to build_image function
DEVARG=""
if ! [ -z $DEVBUILD ]; then
  DEVARG="-dev"
fi


# Check for --log argument to pass to build_image function
LOG=""
if ! [ -z $LOGBUILD ]; then
  echo "Log build to ${LOG_FILE}..."
  log_folder=$(dirname $LOG_FILE)
  if ! [ -d "$log_folder" ]; then
    mkdir -p $log_folder
  fi
  if ! [ -d "$log_folder" ]; then
    echo "Couldn't create ${log_folder}, exit."
    exit 1
  fi
  LOG=" | tee -a ${LOG_FILE}"
fi

# check for custom app repo
if ! [ -z ${APP_REPO} ]; then
  xmrsigner_app_repo="${APP_REPO}"
fi

# check for custom app branch
if ! [ -z ${APP_BRANCH} ]; then
  xmrsigner_app_repo_branch="${APP_BRANCH}"
fi

# check for custom app branch
if ! [ -z ${APP_COMMITID} ]; then
  xmrsigner_app_repo_commit_id="${APP_COMMITID}"
fi

###
### Run build_image function based on input arguments
###

# Build All Architectures
if ! [ -z ${ALL_FLAG} ]; then
  build_image "pi0${DEVARG}" "clean" "${SKIPREPO_ARG}" $LOG
  build_image "pi02w${DEVARG}" "clean" "skip-repo" $LOG
fi

# Build only for pi0, pi0w, and pi1
if ! [ -z ${PI0_FLAG} ]; then
  build_image "pi0${DEVARG}" "${CLEAN_ARG}" "${SKIPREPO_ARG}" $LOG
fi

# build for pi02w
if ! [ -z ${PI02W_FLAG} ]; then
  build_image "pi02w${DEVARG}" "${CLEAN_ARG}" "${SKIPREPO_ARG}" $LOG
fi

if ! [ -z $LOGBUILD ]; then
  mkdir -p /images/log/
  echo "PWD: ${PWD} LOGFILE: ${LOG_FILE}"
  cp $LOG_FILE /images/log/
fi

exit 0
