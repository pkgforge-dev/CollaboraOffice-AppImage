#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini

# Comment this out if you need an AUR package
make-aur-package collabora-office

# remove dicts since this can use the system hunspell dicts instead
rm -rf /usr/lib/collabora-office/share/extensions

# remove heavy bundled fonts since they can be used from the host
d=/usr/lib/collabora-office/share/fonts/truetype
rm -f "$d"/Noto* "$d"/LinLibertine*

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
