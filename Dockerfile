FROM liyaosong/debootstrap AS build

ARG NAME=bionic
ARG BASE_URL=http://mirrors.ustc.edu.cn/ubuntu/
USER root
RUN debootstrap \
    --variant=minbase ${NAME} ubuntu-root ${BASE_URL}

RUN chroot ubuntu-root apt-get update && \
    chroot ubuntu-root apt-get upgrade -y && \
    chroot ubuntu-root apt-get autoremove -y && \
    chroot ubuntu-root apt-get clean
    
RUN chroot ubuntu-root useradd -m ubuntu

RUN rm -rf \
    ubuntu-root/var/lib/apt/lists/* \
    ubuntu-root/tmp/* \
    ubuntu-root/var/tmp/* \
    ubuntu-root/root/.cache \
    ubuntu-root/var/cache/apt/archives/*.deb \
    ubuntu-root/var/cache/apt/*.bin \
    ubuntu-root/var/lib/apt/lists/* \
    ubuntu-root/usr/share/*/*/*/*.gz \
    ubuntu-root/usr/share/*/*/*.gz \
    ubuntu-root/usr/share/*/*.gz \
    ubuntu-root/usr/share/doc/*/README* \
    ubuntu-root/usr/share/doc/*/*.txt \
    ubuntu-root/usr/share/locale/*/LC_MESSAGES/*.mo 


FROM scratch
ARG VERSION=18.04
LABEL maintainer="liyaosong <liyaosong1@qq.com>"
LABEL version=${VERSION}
LABEL description="ubuntu image."

COPY --from=build /ubuntu-root /