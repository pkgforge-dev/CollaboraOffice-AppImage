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
export ICON="https://raw.githubusercontent.com/CollaboraOnline/online/refs/heads/distro/collabora/coda-$VERSION/qt/hicolor/scalable/apps/com.collaboraoffice.Office.startcenter.svg"
export DESKTOP="https://raw.githubusercontent.com/CollaboraOnline/online/refs/heads/distro/collabora/coda-$VERSION/qt/com.collaboraoffice.Office.desktop"
export META="https://raw.githubusercontent.com/CollaboraOnline/online/refs/heads/distro/collabora/coda-$VERSION/qt/com.collaboraoffice.Office.metainfo.xml"
export OUTNAME=CODA-"$VERSION"-anylinux-"$ARCH".AppImage
export ANYLINUX_LIB=1
export OPTIMIZE_LAUNCH=1
export LOCOREPATH="$CORE_PATH"
export PATH_MAPPING_HARDCODED=coda-qt

# Deploy dependencies
quick-sharun /usr/bin/coda-qt \
    /usr/share/coda-qt \
    /usr/share/coolwsd \
    /usr/lib/core


echo 'LOCOREPATH=${SHARUN_DIR}/lib/core' >> ./AppDir/.env
echo 'COOL_TOPSRCDIR=${SHARUN_DIR}/share/coolwsd' >> ./AppDir/.env
echo 'LC_CTYPE=en_US.UTF-8' >> ./AppDir/.env


# Turn AppDir into AppImage
quick-sharun --make-appimage
