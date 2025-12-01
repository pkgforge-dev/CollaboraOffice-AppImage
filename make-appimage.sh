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
export ANYLINUX_LIB=1
#export DESKTOP=PATH_OR_URL_TO_DESKTOP_ENTRY
export OPTIMIZE_LAUNCH=1

# Deploy dependencies
quick-sharun /usr/bin/coda-qt \
    /usr/share/coda-qt \
    /usr/share/coolwsd

cp -r "$CODA_PATH"/browser ./AppDir
cp -r "$CODA_PATH"/core ./AppDir

echo '#!/bin/sh
mkdir -p /tmp/CODA
ln -sfn "$APPDIR"/browser /tmp/CODA/browser
ln -sfn "$APPDIR"/core /tmp/CODA/core
' > ./AppDir/bin/fix-bruhmoment.hook

chmod +x ./AppDir/bin/fix-bruhmoment.hook

# debloat
rm -rf \
    ./AppDir/core/include         \
    ./AppDir/browser/po           \
    ./AppDir/browser/node_modules \
    ./AppDir/browser/archived-packages

# Turn AppDir into AppImage
quick-sharun --make-appimage
