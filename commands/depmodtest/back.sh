#!/bin/bash
#create by SSY
aimDir=./
mv /lib/modules/$(uname -r)/kernel/cal.ko $aimDir
mv /lib/modules/$(uname -r)/kernel/usecal.ko $aimDir

