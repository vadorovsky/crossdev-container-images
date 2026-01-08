#!/bin/bash

source /etc/profile
source /env
CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_RUNNER=qemu-x86_64

exec "$@"
