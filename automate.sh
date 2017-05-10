#!/bin/bash

wget -P /usr/local/packer -nd -r -l1 --no-parent -A "r1*.iso" "http://<path to iso>/"
#this is to download only a required iso file starting with r1... from a directory that has multiple iso files

iso="$(ls -t | grep "r1*" | head -n1 )"
#if there are multiple r1.iso files tehn select the latest file 

echo $iso

#changing the iso_url, iso_checksum parameters in template
MD5CKSUM=`md5sum $iso | cut -d' ' -f1`
echo $MD5CKSUM


URL="iso_url"

NEWURL='      \"iso_url\" : \"'"$iso"'\",'
echo $NEWURL
sed -i '/\<'"$URL"'\>/c\'"$NEWURL"'' template.json  #template.json is ur packer template

CHKSUM="iso_checksum"
NEWCKSUM='      \"iso_checksum\" : \"'"$MD5CKSUM"'\",'
echo $NEWCKSUM
sed -i '/\<'"$CHKSUM"'\>/c\'"$NEWCKSUM"'' template.json

sleep 10

#Running Packer with debugging enabled
PACKER_LOG=1 packer build template.json
