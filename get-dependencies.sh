#!/bin/sh

set -eu

cd /tmp

ARCH=$(uname -m)
VERSION="25.04"
CODA_PATH="$(pwd)/CODA"
CORE_PATH="$CODA_PATH/core"
PREFIX="/usr"

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

echo "Getting Collabora Office Asset Pack for $VERSION..."
echo "---------------------------------------------------------------"
mkdir -p $CORE_PATH
cd $CORE_PATH
wget https://github.com/CollaboraOnline/online/releases/download/for-code-assets/core-co-$VERSION-assets.tar.gz
tar xvf core-co-$VERSION-assets.tar.gz
rm -rf core-co-$VERSION-assets.tar.gz

echo "Compiling Collabora Office for $VERSION..."
echo "---------------------------------------------------------------"
cd $CODA_PATH
./autogen.sh
./configure --prefix="$PREFIX" --enable-qtapp --with-lo-path="$CORE_PATH/instdir" --with-lokit-path="$CORE_PATH/include" --enable-debug CXXFLAGS="-O2 -g -fPIC"
make -j$(nproc)
make install

echo "We should get a coda-qt now. Let's search for it:"
echo "---------------------------------------------------------------"
#find . -name "coda-qt"
whereis coda-qt

echo "$VERSION"> ~/version
echo "$CODA_PATH" > ~/CODA_PATH