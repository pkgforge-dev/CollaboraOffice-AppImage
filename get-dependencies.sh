#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	cmake          \
	cppunit        \
	curl           \
	gperf          \
	graphite       \
	harfbuzz-icu   \
	hunspell       \
	hyphen         \
	libmythes      \
	nasm           \
	ninja          \
	nodejs         \
	npm            \
	python         \
	python-lxml    \
	python-polib   \
	qt6-tools      \
	qt6-webengine  \
	qt6-websockets \
	rsync          \
	zip

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

echo "Getting Collabora Office source..."
echo "---------------------------------------------------------------"
MIRROR=https://github.com/CollaboraOnline/online.mirror
TAG=$(git ls-remote --heads "$MIRROR" | awk -F'/' '/co-/{print $NF}' | grep -v mobile | sed 's|^co-||' | sort -V | tail -1)
if [ -z "$TAG" ]; then
	>&2 echo "no release branch was found"
	exit 1
fi
TAG=$(git ls-remote --tags --sort=-v:refname "$MIRROR" "cp-$TAG*" | head -1 | sed 's|.*refs/tags/||; s|\^{}||')
if [ -z "$TAG" ]; then
	>&2 echo "no cp tag was found"
	exit 1
fi
VERSION=$(echo "$TAG" | sed 's|^cp-||; s|-|.|')
echo "$VERSION" > ~/version

git clone --depth=1 --branch "$TAG" "$MIRROR" ./online

BRAND_URL=$(grep -m1 -o 'https://[^"]*collabora-office-brand[^"]*' ./online/qt/flatpak/com.collaboraoffice.Office.json)
if [ -z "$BRAND_URL" ]; then
	>&2 echo "no branding url in the flatpak manifest"
	exit 1
fi
mkdir -p ./brand
wget "$BRAND_URL" -O /tmp/brand.tar.gz
tar xzf /tmp/brand.tar.gz -C ./brand --strip-components=1

echo "Building Collabora Office engine..."
echo "---------------------------------------------------------------"
(
	cd ./online/engine
	./autogen.sh \
		--with-distro=CPLinuxQtFlatpak \
		--enable-python=internal       \
		--without-fonts                \
		--disable-symbols
	make -j$(nproc)
)

echo "Building Collabora Office..."
echo "---------------------------------------------------------------"
(
	cd ./online
	./autogen.sh
	./configure \
		--prefix=/usr                             \
		--enable-qtapp                            \
		--disable-server                          \
		--disable-ssl                             \
		--disable-werror                          \
		--disable-tests                           \
		--with-lo-builddir="$PWD/engine"          \
		--with-lokit-path="$PWD/engine/include"   \
		--with-lo-path=/usr/lib/collabora-office
	make -j$(nproc)
	sudo make install
)

mkdir -p /usr/lib/collabora-office
cp -a ./online/engine/instdir/. /usr/lib/collabora-office/
cp -a ./brand/online-theme /usr/lib/collabora-office/share/theme_definitions/online/
cp -a ./brand/branding* ./brand/images ./brand/welcome /usr/share/coolwsd/browser/dist/

# remove dicts and heavy bundled fonts, they can be used from the host
rm -rf /usr/lib/collabora-office/share/extensions
d=/usr/lib/collabora-office/share/fonts/truetype
rm -f "$d"/Noto* "$d"/LinLibertine*
