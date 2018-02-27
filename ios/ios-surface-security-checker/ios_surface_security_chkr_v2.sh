#!/bin/sh
##### iOS Surface Secuirty Checker #####
##### Author: Ye Yint Min Thu Htut #####
name="$*"
echo "file name is $name"
name2="$(echo $name | sed 's/\.[^.]*$//')"
echo "Binary file is $name2"
cd "${name}"

fun1=$(otool -Vh "${name2}")
fun2=$(otool -I -v "${name2}" | grep stack_chk_guard)
fun3=$(otool -I -v "${name2}" | grep _objc_releases)

echo "\n[1]PIE flag checking...\n"
echo "$fun1\n\n"

echo "\n[2]Stack Flag checking...\n"
echo "$fun2\n\n"

echo "\n[3]fobjc-arc Flag checking...\n"
echo "$fun3\n\n"
