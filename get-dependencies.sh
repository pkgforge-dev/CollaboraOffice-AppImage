#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION="25.04"

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

pacman -Syu --noconfirm \
	base-devel             \
	cmake                  \
	curl                   \
	git                    \
    wget                   \
    libcap                 \
    libcap-ng              \
    libpng                 \
    poco                   \
    cppunit                \
    nodejs                 \
    npm                    \
    chromium               \
    python-lxml            \
    qt6-base               \
    qt6-webengine          \
    qt6-webchannel         \
    python-polib

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano


# If the application needs to be manually built that has to be done down here

echo "Getting Collabora Office source code for $VERSION..."
echo "---------------------------------------------------------------"
#wget --retry-connrefused --tries=30 "$PACKAGE_BUILDER" -O ./make-aur-package.sh
#chmod +x ./make-aur-package.sh
#./make-aur-package.sh --chaotic-aur android_translation_layer-git
git clone https://github.com/CollaboraOnline/online -b distro/collabora/coda-"$VERSION" CODA
git clone https://github.com/LibreOffice/core -b distro/collabora/coda-"$VERSION" core
cd CODA
./autogen.sh
./configure --enable-qtapp --with-lo-path=../core/instdir --with-lokit-path=../core/include --enable-debug CXXFLAGS="-O2 -g -fPIC"
make -j$(nproc)

echo "We should get a coda-qt file now. Let's search for it:"
echo "---------------------------------------------------------------"
find . -name "coda-qt"

echo "$VERSION"> ~/version