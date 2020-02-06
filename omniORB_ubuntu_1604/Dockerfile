FROM ubuntu:16.04

ARG DIR_NAME="omniorb423-u1604"
ARG OMNI="omniORB-4.2.3"

RUN apt update\
 && apt install -y --no-install-recommends \
 python3 \
 python3-all-dev \
 python3-all-dbg \
 doxygen \
 build-essential \
 pkg-config \
 libssl-dev \
 debhelper \
 devscripts \
 fakeroot \
 zlib1g-dev \
 dh-autoreconf

COPY ${DIR_NAME}/${OMNI} /root/${OMNI}
WORKDIR /root/${OMNI}
RUN dpkg-buildpackage -b -us -uc 

RUN mkdir -p /root/omniorb-deb-pkgs \
 && cp /root/*.deb /root/omniorb-deb-pkgs/ \
 && cp /root/omni*.changes /root/omniorb-deb-pkgs/
