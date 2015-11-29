#!/bin/bash

# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j8"
KERNEL="zImage"
DEFCONFIG="geehrc_defconfig"

# Kernel Details
BASE_NEX_VER="NitrogenEX.geehrc"
VER=".1.2"
NEX_VER="$BASE_NEX_VER$VER"

# Vars
export KBUILD_BUILD_USER=nitrogen
export KBUILD_BUILD_HOST=extreme_pc
export CCACHE_DIR=~/.ccache/nitrogenex
export LOCALVERSION=.`echo $NEX_VER`
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=../Linaro-4.9.4/bin/arm-eabi-

# Paths
KERNEL_DIR=`pwd`
REPACK_DIR="${HOME}/AnyKernel-geehrc"
ZIP_MOVE=${HOME}/3.4.0.`echo $NEX_VER`.zip
ZIMAGE_DIR="${HOME}/NitrogenEx/arch/arm/boot"

# Functions
function clean_all {
		rm -rf $REPACK_DIR/tmp/anykernel/zImage
		make clean && make mrproper
}

function make_kernel {
		make $DEFCONFIG
		make $THREAD
		cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/tmp/anykernel
}

function make_zip {
		cd $REPACK_DIR
		zip -9 -r `echo $NEX_VER`.zip .
		mv  `echo $NEX_VER`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}

DATE_START=$(date +"%s")

echo -e "${green}"
echo "Kernel Creation Script:"
echo

echo "---------------"
echo "Kernel Version:"
echo "---------------"

echo -e "${red}"; echo -e "${blink_red}"; echo "$NEX_VER"; echo -e "${restore}";

echo -e "${green}"
echo "-----------------"
echo "Making Kernel:"
echo "-----------------"
echo -e "${restore}"

while read -p "Please choose your option: [1]clean-build / [2]dirty-build / [3]abort " cchoice
do
case "$cchoice" in
	1 )
		echo -e "${green}"
		echo
		echo "[..........Cleaning up..........]"
		echo
		echo -e "${restore}"
		clean_all
		echo -e "${green}"
		echo
		echo "[....Building `echo $NEX_VER`....]"
		echo
		echo -e "${restore}"
		make_kernel
		echo -e "${green}"
		echo
		echo "[....Make `echo $NEX_VER`.zip....]"
		echo
		echo -e "${restore}"
		make_zip
		echo -e "${green}"
		echo
		echo "[.....Moving `echo $NEX_VER`.....]"
		echo
		echo -e "${restore}"
		break
		;;
	2 )
		echo -e "${green}"
		echo
		echo "[....Building `echo $NEX_VER`....]"
		echo
		echo -e "${restore}"
		make_kernel
		echo -e "${green}"
		echo
		echo "[....Make `echo $NEX_VER`.zip....]"
		echo
		echo -e "${restore}"
		make_zip
		echo -e "${green}"
		echo
		echo "[.....Moving `echo $NEX_VER`.....]"
		echo
		echo -e "${restore}"
		break
		;;
	3 )
		break
		;;
	* )
		echo -e "${red}"
		echo
		echo "Invalid try again!"
		echo
		echo -e "${restore}"
		;;
esac
done

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo