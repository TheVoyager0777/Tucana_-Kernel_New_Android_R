#!/bin/bash
args="-j$(nproc --all) \
O=out \
ARCH=arm64 \
CLANG_TRIPLE=/home/user/cer/tc/bin/aarch64-linux-gnu- \
CROSS_COMPILE=/home/user/cer/tc/bin/aarch64-linux-gnu- \
CC=/home/user/cer/clang-r399163b/bin/clang \
CROSS_COMPILE_ARM32=/home/user/cer/tc/bin/arm-linux-gnueabi- "
make ${args} tucanas_defconfig
make ${args}
