#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION="$(cat ~/version)"
CODA_PATH="$(cat ~/CODA_PATH)"
CORE_PATH="$(cat ~/CORE_PATH)"
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON="https://raw.githubusercontent.com/CollaboraOnline/online/refs/heads/distro/collabora/coda-$VERSION/windows/coda/Assets/logo.png"
export DESKTOP="https://raw.githubusercontent.com/CollaboraOnline/online/refs/heads/distro/collabora/coda-$VERSION/qt/com.collabora.Office.desktop"
export META="https://raw.githubusercontent.com/CollaboraOnline/online/refs/heads/distro/collabora/coda-$VERSION/qt/com.collabora.Office.metainfo.xml"
export OUTNAME=CODA-"$VERSION"-anylinux-"$ARCH".AppImage
export ANYLINUX_LIB=1
export OPTIMIZE_LAUNCH=1
export LOCOREPATH="$CORE_PATH"

# Deploy dependencies
quick-sharun /usr/bin/coda-qt \
    /usr/share/coda-qt \
    /usr/share/coolwsd \
    $CORE_PATH


echo 'LOCOREPATH=${SHARUN_DIR}/lib/core' >> ./AppDir/.env
echo 'COOL_TOPSRCDIR=${SHARUN_DIR}/share/coolwsd' >> ./AppDir/.env
echo 'LC_CTYPE=en_US.UTF-8' >> ./AppDir/.env


# Turn AppDir into AppImage
quick-sharun --make-appimage
