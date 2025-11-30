#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION="25.04"

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

pacman -Syu --noconfirm \
    base-devel             \
    chromium               \
    cmake                  \
    cppunit                \
    curl                   \
    git                    \
    libcap                 \
    libcap-ng              \
    libpng                 \
    nodejs                 \
    npm                    \
    poco                   \
    python-lxml            \
    python-polib           \
    qt6-base               \
    qt6-declarative        \
    qt6-tools              \
    qt6-5compat            \
    qt6-webchannel         \
    qt6-webengine          \
    wget                   
echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano


# If the application needs to be manually built that has to be done down here

echo "Getting Collabora Office source code for $VERSION..."
echo "---------------------------------------------------------------"
git clone --depth=1 https://github.com/CollaboraOnline/online -b distro/collabora/coda-"$VERSION" CODA
git clone --depth=1 https://github.com/LibreOffice/core -b distro/collabora/coda-"$VERSION" core
cd CODA
./autogen.sh
./configure --enable-qtapp --with-lo-path=../core/instdir --with-lokit-path=../core/include --enable-debug CXXFLAGS="-O2 -g -fPIC"
make -j$(nproc)
make install

echo "We should get a coda-qt now. Let's search for it:"
echo "---------------------------------------------------------------"
#find . -name "coda-qt"
whereis coda-qt

echo "$VERSION"> ~/version