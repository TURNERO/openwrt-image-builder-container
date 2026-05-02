#!/bin/bash
# Remove conflicting default wpad and add mesh11sd stack
PACKAGES="-wpad-basic-mbedtls wpad-mbedtls luci-ssl luci-app-commands ip-full kmod-nft-bridge vxlan mesh11sd"

# Add your extra custom packages here
EXTRA_PACKAGES="nano htop"

make image PROFILE=$PROFILE \
           PACKAGES="$PACKAGES $EXTRA_PACKAGES" \
           FILES="files/"
