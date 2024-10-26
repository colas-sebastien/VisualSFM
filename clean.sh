#!/bin/bash

cwd=`pwd`
patch=$cwd/patches
dl=$cwd/downloads
build=$cwd/builds
bin=$cwd/bin
lib64=$cwd/lib64

echo -e "${GREEN}Cleaning...${ENDCOLOR}"

rm -fr builds
rm -fr downloads
