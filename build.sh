#!/bin/bash
ANYKERNEL3_DIR=$PWD/AnyKernel3
FINAL_KERNEL_ZIP=kernel-tucana-r-VoyagerIII-$(git rev-parse --short=7 HEAD).zip
IMAGE_GZ=$PWD/out/arch/arm64/boot/Image.gz

export USE_CCACHE=1
export CCACHE_DIR=/home/user/.ccache
args="-j$(nproc --all) \
O=out \
ARCH=arm64 \
LLVM=1\
LLVM_IAS=1\
CLANG_TRIPLE=/home/user/cer/tc/bin/aarch64-linux-gnu- \
CROSS_COMPILE=/home/user/cer/tc/bin/aarch64-linux-gnu- \
CC=/home/user/cer/clang-r433403/bin/clang \
CROSS_COMPILE_ARM32=/home/user/cer/tc/bin/arm-linux-gnueabi- 
AR="llvm-ar" \
NM="llvm-nm" \
OBJCOPY="llvm-objcopy" \
OBJDUMP="llvm-objdump" \
STRIP="llvm-strip" "
make ${args} tucanas_defconfig
make ${args}

echo "**** Verify target files ****"
if [ ! -f "$IMAGE_GZ" ]; then
    echo "!!! Image.gz not found"
    exit 1
fi

echo "**** Moving target files ****"
mv $IMAGE_GZ $ANYKERNEL3_DIR/Image.gz

echo "**** Time to zip up! ****"
cd $ANYKERNEL3_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x .git README.md *placeholder

echo "**** Removing leftovers ****"
cd ..
rm $ANYKERNEL3_DIR/Image.gz

mv -f $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP out/

echo "Check out/$FINAL_KERNEL_ZIP"
