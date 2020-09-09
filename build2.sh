#!/bin/bash
ANYKERNEL3_DIR=$PWD/AnyKernel3
FINAL_KERNEL_ZIP=kernel-tucana-r-VoyagerIII-$(git rev-parse --short=7 HEAD).zip
IMAGE_GZ=$PWD/out/arch/arm64/boot/Image.gz
export ARCH=arm64
export LLVM=1
export LLVM_IAS=1
export PATH=/home/user/cer/tc/bin/:${PATH}
time make O=out CC="ccache clang" ARCH=arm64 tucanas_defconfig
time make -j8 CC="ccache clang" O=out

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
