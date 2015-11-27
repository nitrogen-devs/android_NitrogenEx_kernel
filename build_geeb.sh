#!/bin/bash
export ARCH=arm
export CROSS_COMPILE=../Linaro-4.9.4/bin/arm-eabi-
export CCACHE_DIR=~/.ccache/nitrogenex
export KBUILD_BUILD_USER=mr_mex
export KBUILD_BUILD_HOST=hp_pc
make geeb_defconfig
make -j 8 -o4