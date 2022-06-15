#!/bin/bash
#create by SSY
aimDir=./
mv /lib/modules/$(uname -r)/tree1.ko $aimDir
mv /lib/modules/$(uname -r)/tree2_1.ko $aimDir
mv /lib/modules/$(uname -r)/tree2_2.ko $aimDir
mv /lib/modules/$(uname -r)/tree3_1.ko $aimDir
mv /lib/modules/$(uname -r)/tree3_2.ko $aimDir
mv /lib/modules/$(uname -r)/tree3_4.ko $aimDir
