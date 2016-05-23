#!/bin/bash

nitrogen_dir=nitrogenEx
nitrogen_build_dir=nitrogenEx-build
compiler_dir=../linaro-5.2
compiler_prefix=bin/arm-cortex-linux-gnueabi-
cross_compiler=$compiler_dir/$compiler_prefix

if ! [ -d ~/.ccache/$nitrogen_dir ]; then
	echo -e "${bldred}No ccache directory, creating...${txtrst}"
	mkdir ~/.ccache
	mkdir ~/.ccache/$nitrogen_dir
fi
if ! [ -d ../$nitrogen_build_dir ]; then
	echo -e "${bldred}No $nitrogen_build_dir directory, creating...${txtrst}"
	mkdir ~/$nitrogen_build_dir
	mkdir ~/$nitrogen_build_dir/build_files
fi
if ! [ -d ../$compiler_dir ]; then
	echo -e "${bldred}No $compiler_dir directory, creating...${txtrst}"
	git clone https://github.com/nitrogen-devs/linaro5.2.git $compiler_dir
fi

# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD=$(cat /proc/cpuinfo | grep 'model name' | sed -e 's/.*: //' | wc -l)
KERNEL="zImage"
DEFCONFIG="geeb_defconfig"

# Kernel Details
BASE_NEX_VER="NitrogenEX.geeb"
VER=".3.0"
NEX_VER="$BASE_NEX_VER$VER"

# Vars
export KBUILD_BUILD_USER="Mr.MEX"
export KBUILD_BUILD_HOST="nitrogen-pc"
export CCACHE_DIR=~/.ccache/nitrogenex
export LOCALVERSION=.`echo $NEX_VER`
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=$cross_compiler

# Paths
KERNEL_DIR=`pwd`
REPACK_DIR="anykernel"
ZIP_MOVE=~/$nitrogen_build_dir/3.4.0.`echo $NEX_VER`.zip
ZIMAGE_DIR="arch/arm/boot"

# Functions
function clean_all {
		rm -rf $REPACK_DIR/tmp/anykernel/zImage
		make clean && make mrproper
}

function make_kernel {
		make $DEFCONFIG
		make -j$THREAD
		if [ -f $ZIMAGE_DIR/$KERNEL ]; then
			cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/tmp/anykernel
		else
			echo -e "No zImage!"
		fi
}

function make_zip {
		cd $REPACK_DIR
		zip -9 -r `echo $NEX_VER`.zip .
		if [ -f `echo $NEX_VER`.zip ]; then
			mv  `echo $NEX_VER`.zip $ZIP_MOVE
		else
			echo -e "No zip!"
		fi
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

while read -p "Please choose your option:
1. Clean build
2. Dirty build
3. Abort
:> " cchoice
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
