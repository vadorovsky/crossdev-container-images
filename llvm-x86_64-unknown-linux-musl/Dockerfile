FROM docker.io/gentoo/stage3:llvm

RUN emerge-webrsync \
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
    && crossdev --llvm --show-fail-log --target x86_64-unknown-linux-musl \
    && mkdir -p /usr/x86_64-unknown-linux-musl/etc/portage/binrepos.conf
COPY make.conf /usr/aarch64-unknown-linux-musl/etc/portage/make.conf
COPY gentoobinhost.conf /usr/aarch64-unknown-linux-musl/etc/portage/binrepos.conf/gentoobinhost.conf
RUN PORTAGE_CONFIGROOT=/usr/x86_64-unknown-linux-musl eselect profile set default/linux/amd64/23.0/musl/llvm \
    && x86_64-unknown-linux-musl-emerge --getbinpkg --binpkg-changed-deps=n llvm-runtimes/clang-runtime \
    && x86_64-unknown-linux-musl-emerge --getbinpkg --binpkg-changed-deps=n @system
