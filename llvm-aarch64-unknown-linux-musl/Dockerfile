FROM docker.io/gentoo/stage3:llvm

RUN emerge-webrsync \
    && getuto \
    # `--binpkg-changed-deps=n` is needed, because the binary packages are
    # slightly out of date in comparison to the current Gentoo overlay.
    # That mismatch definitely has to be fixed upstream by building binpkgs
    # more frequently.
    && emerge --getbinpkg --binpkg-changed-deps=n \
        app-eselect/eselect-repository \
        dev-vcs/git \
        sys-apps/merge-usr \
        sys-devel/crossdev \
    && eselect repository create crossdev \
    && crossdev --llvm --show-fail-log --target aarch64-unknown-linux-musl \
    && mkdir -p /usr/aarch64-unknown-linux-musl/etc/portage/binrepos.conf
COPY make.conf /usr/aarch64-unknown-linux-musl/etc/portage/make.conf
COPY gentoobinhost.conf /usr/aarch64-unknown-linux-musl/etc/portage/binrepos.conf/gentoobinhost.conf
RUN PORTAGE_CONFIGROOT=/usr/aarch64-unknown-linux-musl eselect profile set default/linux/arm64/23.0/split-usr/musl/llvm \
    # Install LLVM runtime first, building any sofware won't work without it.
    # Use individual packages instead of llvm-runtimes/clang-runtime, since we
    # are not inserested in installing clang inside sysroot.
    && aarch64-unknown-linux-musl-emerge --getbinpkg --binpkg-changed-deps=n \
        llvm-runtimes/compiler-rt \
        llvm-runtimes/libcxx \
        llvm-runtimes/libcxxabi \
        llvm-runtimes/libunwind \
    && aarch64-unknown-linux-musl-emerge --getbinpkg --binpkg-changed-deps=n \
        app-arch/zstd \
        dev-libs/libxml2 \
        sys-libs/zlib-ng \
        virtual/zlib
