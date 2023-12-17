#!/usr/bin/env bash

set -eou pipefail

# Global constants.
RED='\033[0;31m'
CLEAR='\033[0m'
PATCH_DIR="config/userpatches"
BUILD_DIR="third_party/armbian-build"
USERNAME="nicklasfrahm"

# Global variables.
supported_boards=("nanopi-r5s")
board=""
version=""

parse_args() {
  if [[ $# -ne 2 ]]; then
    echo "usage: $0 <board> <version>"
    exit 1
  fi
  board="$1"
  version="$2"

  is_supported_board=false
  for supported_board in "${supported_boards[@]}"; do
    if [[ "$supported_board" == "$board" ]]; then
      is_supported_board=true
    fi
  done

  if [[ $is_supported_board == false ]]; then
    echo "error: unsupported board: $board"
    exit 1
  fi
}

# Add customizations to the armbian build system.
apply_customizations() {
  # Copy the patch files into the build system.
  cp -r "$PATCH_DIR" third_party/armbian-build
}

# Build the firmware image.
build_firmware() {
  cryptroot_enabled=${CRYPTROOT_ENABLE:-false}
  if [[ "$cryptroot_enabled" == true ]]; then
    "./$BUILD_DIR/compile.sh" build \
      BOARD="$board" \
      BRANCH=edge \
      BUILD_DESKTOP=no \
      BUILD_MINIMAL=yes \
      KERNEL_CONFIGURE=no \
      ROOTFS_TYPE=btrfs \
      CRYPTROOT_ENABLE=yes \
      CRYPTROOT_PARAMETERS="--type luks2 --use-random --cipher aes-xts-plain64 --key-size 512 --hash sha512" \
      CRYPTROOT_PASSPHRASE="$USERNAME" \
      CRYPTROOT_SSH_UNLOCK=yes \
      CRYPTROOT_SSH_UNLOCK_PORT=2222 \
      RELEASE=jammy

    # Cryptroot parameters are configured via build parameters above. For more information, see:
    # Reference: https://github.com/armbian/build/commit/681e58b6689acda6a957e325f12e7b748faa8330
    echo
    echo -e "${RED}CRYPTROOT PASSPHRASE MUST BE ROTATED ON FIRST LOGIN:${CLEAR}"
    echo -e "  sudo cryptsetup luksChangeKey /dev/mmcblk0p2"
    echo
  fi

  "./$BUILD_DIR/compile.sh" build \
    BOARD="$board" \
    BRANCH=edge \
    BUILD_DESKTOP=no \
    BUILD_MINIMAL=yes \
    KERNEL_CONFIGURE=no \
    ROOTFS_TYPE=btrfs \
    RELEASE=jammy
}

# Move the firmware image to the output directory in the root repo.
move_firmware() {
  mkdir -p output
  image_file=$(find "$BUILD_DIR/output/images/" -iname "*$board*.img" | sort -rV | head -n1)
  mv "$image_file" "output/${board}-${version}.img"
}

main() {
  parse_args "$@"

  apply_customizations

  build_firmware
  move_firmware
}

main "$@"
