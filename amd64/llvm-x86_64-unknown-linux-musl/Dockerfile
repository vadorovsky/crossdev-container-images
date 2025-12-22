FROM docker.io/gentoo/stage3:llvm

ARG GENTOO_COMMIT=9809ab46256f1e350745ba22066196048c58ab03

RUN mkdir -p /var/db/repos/gentoo \
    && wget -qO - https://github.com/gentoo/gentoo/archive/${GENTOO_COMMIT}.tar.gz | \
        tar -xz --strip-components=1 -C /var/db/repos/gentoo \
    && getuto \
    # `--binpkg-changed-deps=n` is needed, because the binary packages are
    # slightly out of date in comparison to the current Gentoo overlay.
    # That mismatch definitely has to be fixed upstream by building binpkgs
    # more frequently.
    && emerge --getbinpkg \
        app-eselect/eselect-repository \
        dev-vcs/git \
        sys-devel/crossdev \
    && eselect repository create crossdev \
    && crossdev --llvm --show-fail-log --target x86_64-unknown-linux-musl \
    && mkdir -p /usr/x86_64-unknown-linux-musl/etc/portage/binrepos.conf
COPY make.conf /usr/x86_64-unknown-linux-musl/etc/portage/make.conf
COPY gentoobinhost.conf /usr/x86_64-unknown-linux-musl/etc/portage/binrepos.conf/gentoobinhost.conf
RUN PORTAGE_CONFIGROOT=/usr/x86_64-unknown-linux-musl eselect profile set default/linux/amd64/23.0/split-usr/musl/llvm \
    # Workaround for https://bugs.gentoo.org/968255.
    # Remove once https://github.com/gentoo/gentoo/pull/45221 is merged.
    && mv /usr/x86_64-unknown-linux-musl/lib64/libc++* /usr/x86_64-unknown-linux-musl/usr/lib64 \
    && x86_64-unknown-linux-musl-emerge --getbinpkg \
        app-arch/zstd \
        sys-libs/zlib \
        virtual/zlib
