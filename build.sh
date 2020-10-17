#!/bin/bash
ANYKERNEL3_DIR=$PWD/AnyKernel3
FINAL_KERNEL_ZIP=kernel-alpham-r-VoyagerIII-$(git rev-parse --short=7 HEAD).zip
IMAGE_GZ=$PWD/out/arch/arm64/boot/Image.gz
ccache_=`which ccache`
export ARCH=arm64
export SUBARCH=arm64
export HEADER_ARCH=arm64
export CLANG_PATH=/home/user/cer/clang-r433403

export KBUILD_BUILD_HOST="Voayger-sever"
export KBUILD_BUILD_USER="TheVoyager"

make mrproper O=out || exit 1
make tucanas_defconfig O=out || exit 1

Start=$(date +"%s")

make -j$(nproc --all) \
	O=out \
	CC="${ccache_} ${CLANG_PATH}/bin/clang" \
	CLANG_TRIPLE=/home/user/fc/aarch64-linux-gnu- \
	CROSS_COMPILE=/home/user/fc/bin/aarch64-linux-gnu- \
	CROSS_COMPILE_ARM32=/home/user/fc/bin/arm-linux-gnueabi- 

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

exit_code=$?
End=$(date +"%s")
Diff=$(($End - $Start))

echo "Check out/$FINAL_KERNEL_ZIP"
