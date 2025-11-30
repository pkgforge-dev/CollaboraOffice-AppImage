#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION="$(cat ~/version)"
CODA_PATH="$(cat ~/CODA_PATH)"

export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON="https://raw.githubusercontent.com/CollaboraOnline/online/refs/heads/distro/collabora/coda-$VERSION/windows/coda/Assets/logo.png"
export OUTNAME=CODA-"$VERSION"-anylinux-"$ARCH".AppImage
#export DESKTOP=PATH_OR_URL_TO_DESKTOP_ENTRY
#export DEPLOY_QT=1


# Deploy dependencies
quick-sharun /usr/bin/coda-qt \
    /usr/share/coda-qt \
    /usr/share/coolwsd

cp -r "$CODA_PATH"/browser ./AppDir

echo '#!/bin/sh
mkdir -p /tmp/CODA
ln -sfn "$APPDIR"/browser /tmp/CODA/browser
' > ./AppDir/bin/fix-bruhmoment.hook

chmod +x ./AppDir/bin/fix-bruhmoment.hook

# Turn AppDir into AppImage
quick-sharun --make-appimage
