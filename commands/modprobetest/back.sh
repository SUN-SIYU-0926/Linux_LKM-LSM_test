#!/bin/bash
#create by SSY
aimDir=./
mv /lib/modules/$(uname -r)/cal.ko $aimDir
mv /lib/modules/$(uname -r)/usecal.ko $aimDir

