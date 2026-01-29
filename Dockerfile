FROM docker.io/gentoo/stage3:llvm

ARG TARGETARCH
ARG CROSSDEV_TOOLCHAIN
ARG CROSSDEV_TARGET
ARG CROSSDEV_PROFILE
ARG CROSSDEV_EXTRA_ARGS
ARG EXTRA_PACKAGES

COPY package.use/static /etc/portage/package.use/
COPY ${CROSSDEV_TOOLCHAIN}-${CROSSDEV_TARGET}/env /
COPY ${TARGETARCH}/${CROSSDEV_TARGET}/entrypoint.sh /
COPY ${TARGETARCH}/${CROSSDEV_TARGET}/package.use/qemu /etc/portage/package.use/
RUN emerge-webrsync \
    && getuto \
    && emerge --getbinpkg \
        app-eselect/eselect-repository \
        dev-vcs/git \
        sys-devel/crossdev \
        ${EXTRA_PACKAGES} \
    && eselect repository remove -f gentoo \
    && eselect repository add gentoo git https://github.com/gentoo-mirror/gentoo \
    && eselect repository add vad git https://github.com/vadorovsky/overlay \
    && eselect repository create crossdev \
    && crossdev ${CROSSDEV_EXTRA_ARGS} --show-fail-log \
        --target ${CROSSDEV_TARGET} \
    && mkdir -p /usr/${CROSSDEV_TARGET}/etc/portage/{binrepos.conf,package.use}
COPY package.accept_keywords /usr/${CROSSDEV_TARGET}/etc/portage/
COPY package.use/static /usr/${CROSSDEV_TARGET}/etc/portage/package.use/
COPY ${TARGETARCH}/${CROSSDEV_TARGET}/make.conf \
        /usr/${CROSSDEV_TARGET}/etc/portage/
COPY ${CROSSDEV_TOOLCHAIN}-${CROSSDEV_TARGET}/gentoobinhost.conf \
        /usr/${CROSSDEV_TARGET}/etc/portage/binrepos.conf/
RUN PORTAGE_CONFIGROOT=/usr/${CROSSDEV_TARGET} \
      eselect profile set ${CROSSDEV_PROFILE} \
    && ${CROSSDEV_TARGET}-emerge --getbinpkg \
      app-arch/zstd \
      app-shells/bash \
      net-misc/curl \
      sys-apps/baselayout \
      sys-apps/coreutils \
      sys-apps/grep \
      sys-libs/musl \
      sys-libs/zlib \
      virtual/zlib \
    # The order of installation of clang runtime packages is messed up on
    # cross environments and should be addressed by:
    # https://github.com/gentoo/gentoo/pull/45492
    && ${CROSSDEV_TARGET}-emerge --getbinpkg \
      llvm-core/clang-linker-config \
    && ${CROSSDEV_TARGET}-emerge --getbinpkg \
      llvm-runtimes/clang-rtlib-config \
    && ${CROSSDEV_TARGET}-emerge --getbinpkg \
      llvm-runtimes/clang-unwindlib-config \
    && ${CROSSDEV_TARGET}-emerge --getbinpkg \
      llvm-runtimes/clang-stdlib-config \
    && ${CROSSDEV_TARGET}-emerge --getbinpkg \
      llvm-runtimes/clang-runtime \
      llvm-runtimes/libgcc

ENTRYPOINT ["/entrypoint.sh"]
