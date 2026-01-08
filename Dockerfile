FROM docker.io/gentoo/stage3:llvm

ARG TARGETARCH
ARG GENTOO_COMMIT
ARG CROSSDEV_TOOLCHAIN
ARG CROSSDEV_TARGET
ARG CROSSDEV_PROFILE
ARG CROSSDEV_EXTRA_ARGS
ARG EXTRA_PACKAGES

COPY ${CROSSDEV_TOOLCHAIN}-${CROSSDEV_TARGET}/env /
COPY ${TARGETARCH}/${CROSSDEV_TARGET}/entrypoint.sh /
COPY package.use/static /etc/portage/package.use/
COPY ${TARGETARCH}/${CROSSDEV_TARGET}/package.use/qemu /etc/portage/package.use/
RUN mkdir -p /var/db/repos/gentoo \
    && wget -qO - \
        https://github.com/gentoo/gentoo/archive/${GENTOO_COMMIT}.tar.gz | \
        tar -xz --strip-components=1 -C /var/db/repos/gentoo \
    && getuto \
    && emerge --getbinpkg \
        app-eselect/eselect-repository \
        dev-vcs/git \
        sys-devel/crossdev \
        ${EXTRA_PACKAGES} \
    && eselect repository create crossdev \
    && crossdev ${CROSSDEV_EXTRA_ARGS} --show-fail-log \
        --target ${CROSSDEV_TARGET} \
    && mkdir -p /usr/${CROSSDEV_TARGET}/etc/portage/binrepos.conf
COPY ${TARGETARCH}/${CROSSDEV_TARGET}/make.conf \
        /usr/${CROSSDEV_TARGET}/etc/portage/
COPY ${CROSSDEV_TOOLCHAIN}-${CROSSDEV_TARGET}/gentoobinhost.conf \
        /usr/${CROSSDEV_TARGET}/etc/portage/binrepos.conf/
RUN PORTAGE_CONFIGROOT=/usr/${CROSSDEV_TARGET} \
      eselect profile set ${CROSSDEV_PROFILE} \
    && ${CROSSDEV_TARGET}-emerge --getbinpkg \
        app-arch/zstd \
        sys-libs/zlib \
        virtual/zlib

ENTRYPOINT ["/entrypoint.sh"]
