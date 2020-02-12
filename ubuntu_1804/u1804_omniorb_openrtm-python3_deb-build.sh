#!/bin/bash
#
# omniORB 4.2.3 build script for Ubuntu.
#
# Patch the debian directory of omniORB omniORBpy 4.2.2.
# Use this to create a deb package for omniORB and omniORBpy 4.2.3
# in docker environment.
# After that, create a deb package for Python3 of OpenRTM-aist-Python.
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
DIST_NAME=ubuntu1804

OMNI_SHORT_VER=`echo ${OMNI_VER} | sed 's/\.//g'`
OMNI_SRC_DIR=${TARGET}-src
OMNIPY_SRC_DIR=${TARGET}py-src
IMAGE_NAME=${TARGET}${OMNI_SHORT_VER}
CONTAINER_NAME=${IMAGE_NAME}-${DIST_NAME}

printf "sudo password: "
stty -echo
read password
stty echo
if test -d ${OMNI_SRC_DIR}; then
  rm -rf ${OMNI_SRC_DIR}
fi
mkdir ${OMNI_SRC_DIR}
if test -d ${OMNIPY_SRC_DIR}; then
  rm -rf ${OMNIPY_SRC_DIR}
fi
mkdir ${OMNIPY_SRC_DIR}

# Get the debian directory from the package creation source.
# Apply patches.
##----- omniORB
cd ${OMNI_SRC_DIR}
wget https://sourceforge.net/projects/omniorb/files/omniORB/omniORB-${OMNI_VER}/omniORB-${OMNI_VER}.tar.bz2
tar xf omniORB-${OMNI_VER}.tar.bz2

echo "${password}" | sudo -S apt install -y dpkg-dev 
apt source omniorb
OMNI_PKG_SRC_DIR=`ls -d omniorb-dfsg*/`
OMNI_PKG_SRC_NAME=`echo ${OMNI_PKG_SRC_DIR} | sed 's/\///'`
cp -r ${OMNI_PKG_SRC_NAME}/debian omniORB-${OMNI_VER}/
rm -rf omniorb-dfsg*

patch -d omniORB-${OMNI_VER}/debian < ../omniORB-${OMNI_VER}_debian.patch
cd -

##---- omniORBpy
cd ${OMNIPY_SRC_DIR}
wget https://sourceforge.net/projects/omniorb/files/omniORBpy/omniORBpy-${OMNI_VER}/omniORBpy-${OMNI_VER}.tar.bz2
tar xf omniORBpy-${OMNI_VER}.tar.bz2

apt source python-omniorb
OMNI_PKG_SRC_DIR=`ls -d python-omniorb*/`
OMNI_PKG_SRC_NAME=`echo ${OMNI_PKG_SRC_DIR} | sed 's/\///'`
cp -r ${OMNI_PKG_SRC_NAME}/debian omniORBpy-${OMNI_VER}/
rm -rf python-omniorb*

patch -d omniORBpy-${OMNI_VER}/debian < ../omniORBpy-${OMNI_VER}_debian.patch
cd -

# Source build in docker environment.
echo "${password}" | sudo -S docker build -t ${IMAGE_NAME} .
echo "${password}" | sudo -S docker create --name ${CONTAINER_NAME} ${IMAGE_NAME}
echo "${password}" | sudo -S docker cp ${CONTAINER_NAME}:/root/artifacts .
echo "${password}" | sudo -S docker rm ${CONTAINER_NAME}
