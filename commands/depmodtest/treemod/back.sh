#!/bin/bash
#create by SSY
aimDir=./
mv /lib/modules/$(uname -r)/kernel/tree1.ko $aimDir
mv /lib/modules/$(uname -r)/kernel/tree2_1.ko $aimDir
mv /lib/modules/$(uname -r)/kernel/tree2_2.ko $aimDir
mv /lib/modules/$(uname -r)/kernel/tree3_1.ko $aimDir
mv /lib/modules/$(uname -r)/kernel/tree3_2.ko $aimDir
mv /lib/modules/$(uname -r)/kernel/tree3_4.ko $aimDir
