#! /bin/bash

#author:			jesusFx
#date:				15/02/2020
#bash_version:		4.4.20
#script_version:	0.0.1
#description:		Script to download latest staging version of Widevine component (neccesary component to play DRM content in 
#					different browsers to Chrome)

STAGING_WIDEVINE_URL_ROOT="http://archive.virtapi.org/packages/c/chromium-widevine/"
STAGING_WIDEVINE_PACKAGE=$(curl -s $STAGING_WIDEVINE_URL_ROOT | tail -n3 | head -n1 | grep -oE "chromium-widevine.*.pkg.tar.xz")
STAGING_WIDEVINE_URL="$STAGING_WIDEVINE_URL_ROOT$STAGING_WIDEVINE_PACKAGE"

wget $STAGING_WIDEVINE_URL

BASH_WIDEVINE_PACKAGE=$(echo "$STAGING_WIDEVINE_PACKAGE" | sed -E 's/(%3A)/\:/')
RENAME_WIDEVINE_PACKAGE=$(echo "$STAGING_WIDEVINE_PACKAGE" | sed -E 's/(%3A)/\-/')

EXTRACT_DIRECTORY="stagingWidevine/"

sudo mv $BASH_WIDEVINE_PACKAGE $RENAME_WIDEVINE_PACKAGE
sudo mkdir $EXTRACT_DIRECTORY
sudo tar xf $RENAME_WIDEVINE_PACKAGE -C $EXTRACT_DIRECTORY
sudo rm $RENAME_WIDEVINE_PACKAGE
echo "Staging Widevine directory is in $(pwd)/$EXTRACT_DIRECTORY"