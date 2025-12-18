FROM docker.io/gentoo/stage3:llvm

ARG GENTOO_COMMIT=f0295f5e59b1ac0787c37adee66275485ba4eadb

RUN mkdir -p /var/db/repos/gentoo \
    && wget -qO - https://github.com/gentoo/gentoo/archive/${GENTOO_COMMIT}.tar.gz | \
        tar -xz --strip-components=1 -C /var/db/repos/gentoo \
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
    # Workaround for https://bugs.gentoo.org/968255.
    # Remove once https://github.com/gentoo/gentoo/pull/45221 is merged.
    && mv /usr/aarch64-unknown-linux-musl/lib64/libc++* /usr/aarch64-unknown-linux-musl/usr/lib64 \
    && aarch64-unknown-linux-musl-emerge --getbinpkg --binpkg-changed-deps=n \
        app-arch/zstd \
        sys-libs/zlib \
        virtual/zlib
