#!/bin/bash

yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'

ANYKERNEL3_DIR=$PWD/AnyKernel3
FINAL_KERNEL_ZIP=kernel-Tucana-r-VoyagerIII-$(git rev-parse --short=7 HEAD).zip
IMAGE_GZ=$PWD/out/arch/arm64/boot/Image.gz-dtb
DTBO_IMG=$PWD/out/arch/arm64/boot/dtbo.img
ccache_=`which ccache`

export ARCH=arm64
export SUBARCH=arm64
export HEADER_ARCH=arm64
export CLANG_PATH=/home/user/cer/clang-r433403

export KBUILD_BUILD_HOST="Voayger-sever"
export KBUILD_BUILD_USER="TheVoyager"

make mrproper O=out || exit 1
make tucana_user_defconfig O=out || exit 1

Start=$(date +"%s")

make -j$(nproc --all) \
	O=out \
	CC="${ccache_} ${CLANG_PATH}/bin/clang" \
	CLANG_TRIPLE=/home/user/fc/aarch64-linux-gnu- \
	CROSS_COMPILE=/home/user/fc/bin/aarch64-linux-gnu- \
	CROSS_COMPILE_ARM32=/home/user/fc/bin/arm-linux-gnueabi- || > ./build.log

exit_code=$?
End=$(date +"%s")
Diff=$(($End - $Start))

echo "**** Verify target files ****"
if [ ! -f "$IMAGE_GZ" ]; then
    echo "!!! Image.gz not found"
    exit 1
fi

echo "**** Moving target files ****"
mv -f $IMAGE_GZ $ANYKERNEL3_DIR/Image.gz-dtb
mv -f $DTBO_IMG $ANYKERNEL3_DIR/dtbo.img

echo "**** Time to zip up! ****"
cd $ANYKERNEL3_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x .git README.md *placeholder

echo "**** Removing leftovers ****"
cd ..
rm $ANYKERNEL3_DIR/Image.gz-dtb
rm $ANYKERNEL3_DIR/dtbo.img

mv -f $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP out/
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >> \n $white"
echo "Check out/$FINAL_KERNEL_ZIP"
