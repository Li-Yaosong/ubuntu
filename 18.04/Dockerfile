FROM liyaosong/debootstrap AS build

USER root

ENV AMD_BASE_URL=http://mirrors.ustc.edu.cn/ubuntu/
ENV ARM_BASE_URL=http://mirrors.ustc.edu.cn/ubuntu-ports/
RUN echo '#!/bin/bash' >> /install-root.sh
RUN echo 'if [ `uname -m` == "aarch64" ]; then' >> /install-root.sh
RUN echo '    export BASE_URL=${ARM_BASE_URL}' >> /install-root.sh
RUN echo 'else' >> /install-root.sh
RUN echo '    export BASE_URL=${AMD_BASE_URL}' >> /install-root.sh
RUN echo 'fi' >> /install-root.sh
RUN echo 'debootstrap --variant=minbase --components=main,restricted,universe,multiverse bionic ubuntu-root ${BASE_URL}' >> /install-root.sh

RUN chmod +x /install-root.sh && /install-root.sh

RUN echo '#!/bin/bash' >> /insert-sources.sh
RUN echo 'if [ `uname -m` == "aarch64" ]; then' >> /insert-sources.sh
RUN echo '    export BASE_URL=${ARM_BASE_URL}' >> /insert-sources.sh
RUN echo 'else' >> /insert-sources.sh
RUN echo '    export BASE_URL=${AMD_BASE_URL}' >> /insert-sources.sh
RUN echo 'fi' >> /insert-sources.sh
RUN echo 'echo "# deb-src ${BASE_URL} bionic main restricted universe multiverse" >> /ubuntu-root/etc/apt/sources.list' >> /insert-sources.sh
RUN echo 'echo "deb ${BASE_URL} bionic-updates main restricted universe multiverse" >> /ubuntu-root/etc/apt/sources.list' >> /insert-sources.sh
RUN echo 'echo "# deb-src ${BASE_URL} bionic-updates main restricted universe multiverse" >> /ubuntu-root/etc/apt/sources.list' >> /insert-sources.sh
RUN echo 'echo "deb ${BASE_URL} bionic-backports main restricted universe multiverse" >> /ubuntu-root/etc/apt/sources.list' >> /insert-sources.sh
RUN echo 'echo "# deb-src ${BASE_URL} bionic-backports main restricted universe multiverse" >> /ubuntu-root/etc/apt/sources.list' >> /insert-sources.sh

RUN chmod +x /insert-sources.sh && /insert-sources.sh

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
LABEL maintainer="liyaosong <liyaosong1@qq.com>"
LABEL version=18.04
LABEL description="ubuntu 18.04 image."

COPY --from=build /ubuntu-root /