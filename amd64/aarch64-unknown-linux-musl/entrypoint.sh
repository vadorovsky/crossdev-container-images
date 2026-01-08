#!/bin/bash

source /etc/profile
source /env
export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_RUNNER=qemu-aarch64

exec "$@"
