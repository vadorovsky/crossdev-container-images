#!/bin/bash

source /etc/profile
source /env
CARGO_TARGET_RISCV64_UNKNOWN_LINUX_MUSL_RUNNER=qemu-aarch64

exec "$@"
