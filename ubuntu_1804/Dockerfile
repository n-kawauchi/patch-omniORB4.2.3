FROM ubuntu:18.04 as omniorb-build

ARG OMNI_TOP="omniorb-src"
ARG OMNI_SRC="omniORB-4.2.3"
ARG ARTIFACTS="artifacts"

RUN sed -i -e 's%archive.ubuntu.com/ubuntu%ftp.riken.go.jp/Linux/ubuntu/%g' /etc/apt/sources.list
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
 zlib1g-dev

COPY ${OMNI_TOP}/${OMNI_SRC} /root/${OMNI_SRC}
WORKDIR /root/${OMNI_SRC}
RUN dpkg-buildpackage -b -us -uc 

RUN mkdir -p /root/${ARTIFACTS} \
 && cp /root/omni*deb /root/${ARTIFACTS}/ \
 && cp /root/omni*buildinfo /root/${ARTIFACTS}/ \
 && cp /root/omni*changes /root/${ARTIFACTS}/ \
 && cp /root/lib*.deb /root/${ARTIFACTS}/

WORKDIR /root/${ARTIFACTS}
RUN dpkg -i libomnithread4_4.2.3-0.1_amd64.deb \
 && dpkg -i libomniorb4-2_4.2.3-0.1_amd64.deb \
 && dpkg -i libomnithread4-dev_4.2.3-0.1_amd64.deb \
 && dpkg -i libomniorb4-dev_4.2.3-0.1_amd64.deb \
 && dpkg -i omniidl_4.2.3-0.1_amd64.deb \
 && dpkg -i omniorb-nameserver_4.2.3-0.1_amd64.deb \
 && dpkg -i omniorb-idl_4.2.3-0.1_all.deb

##### build omniORBpy

ARG OMNIPY_TOP="omniorbpy-src"
ARG OMNIPY_SRC="omniORBpy-4.2.3"

RUN apt install -y --no-install-recommends \
 python-all-dev \
 python-all-dbg 

COPY ${OMNIPY_TOP}/${OMNIPY_SRC} /root/${OMNIPY_SRC}
WORKDIR /root/${OMNIPY_SRC}
RUN dpkg-buildpackage -b -us -uc

RUN cp /root/*deb /root/${ARTIFACTS}/ \
 && cp /root/*buildinfo /root/${ARTIFACTS}/ \
 && cp /root/*changes /root/${ARTIFACTS}/

WORKDIR /root/${ARTIFACTS}
RUN dpkg -i omniidl-python3_4.2.3-0.1_all.deb \
 && dpkg -i python3-omniorb_4.2.3-0.1_amd64.deb \
 && dpkg -i python3-omniorb-omg_4.2.3-0.1_all.deb
