#!/bin/bash
#
# omniORB 4.2.3 build script for Ubuntu.
#
# Patch the debian directory of omniORB 4.2.2.
# Use this to create a deb package for omniORB 4.2.3 in docker environment.
#
# Usage:
#   $ sh u1804-omni423-deb-build.sh
#   $ ls omniorb-deb-pkgs
#   libcos4-2_4.2.3-0.1_amd64.deb   libomnithread4-dev_4.2.3-0.1_amd64.deb
#   omniidl_4.2.3-0.1_amd64.deb     omniorb_4.2.3-0.1_amd64.deb
#      :
#
TARGET=omniorb
OMNI_VER=4.2.3
DIST_NAME=u1804

OMNI_SHORT_VER=`echo ${OMNI_VER} | sed 's/\.//g'`
DIR_NAME=${TARGET}${OMNI_SHORT_VER}-${DIST_NAME}
IMAGE_NAME=${DIR_NAME}
CONTAINER_NAME=${DIR_NAME}

printf "sudo password: "
stty -echo
read password
stty echo
if test -d ${DIR_NAME}; then
  rm -rf ${DIR_NAME}
fi
mkdir ${DIR_NAME}

cd ${DIR_NAME}
wget https://sourceforge.net/projects/omniorb/files/omniORB/omniORB-${OMNI_VER}/omniORB-${OMNI_VER}.tar.bz2
tar xf omniORB-${OMNI_VER}.tar.bz2

# Get the debian directory from the package creation source.
apt source omniorb
OMNI_PKG_SRC_DIR=`ls -d omniorb-dfsg*/`
OMNI_PKG_SRC_NAME=`echo ${OMNI_PKG_SRC_DIR} | sed 's/\///'`
cp -r ${OMNI_PKG_SRC_NAME}/debian omniORB-${OMNI_VER}/
rm -rf omniorb-dfsg*

patch -d omniORB-${OMNI_VER}/debian < ../omniORB-${OMNI_VER}_debian.patch
cd -

# Source build in docker environment.
echo "${password}" | sudo -S docker build -t ${IMAGE_NAME} .
echo "${password}" | sudo -S docker create --name ${CONTAINER_NAME} ${IMAGE_NAME}
echo "${password}" | sudo -S docker cp ${CONTAINER_NAME}:/root/omniorb-deb-pkgs .
echo "${password}" | sudo -S docker rm ${CONTAINER_NAME}
