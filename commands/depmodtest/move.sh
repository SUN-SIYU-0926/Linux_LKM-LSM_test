#!/bin/bash
#create by SSY
aimDir=/lib/modules/$(uname -r)/kernel
mv cal.ko $aimDir
mv usecal.ko $aimDir


