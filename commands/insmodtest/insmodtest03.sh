#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: SunSiyu
#
# 内容：用insmod加载一个依赖于已加载模块的模块，若模块成功加载，按依赖移除模块。
# 期望结果：加载目标模块成功。

TST_CLEANUP=cleanup
TST_TESTFUNC=run
TST_SETUP=setup
TST_NEEDS_ROOT=1
TST_NEEDS_CMDS="rmmod insmod"
TST_NEEDS_MODULE="usecal.ko"
endt=0
. tst_test.sh

inserted=0

cleanup()
{
	if [ $endt -eq 1 ] ; then
		return 
	fi
	if [ $inserted -ne 0 ]; then
		tst_res TINFO "insmodtest03: running rmmod usecal"
		rmmod usecal.ko
		rmmod cal.ko
		if [ $? -ne 0 ]; then
			tst_res TWARN "insmodtest03: failed to rmmod usecal"
		fi
		inserted=0
	fi
	echo ***************insmod_test03***************
}

setup()
{
	insmod cal.ko
	if [ $? -ne 0 ]; then
		endt=1
		tst_res TWARN "insmodtest03: failed to prepare cal.ko for test03"
		touch result/insE03_1
	fi
	
}

run()
{
	if [ $endt -eq 1 ] ; then
		return 
	fi
	insmod "$TST_MODPATH"
	if [ $? -ne 0 ]; then
		tst_res TFAIL "insmodtest03: FAILED,command failed to execute."
		touch result/insF03_1
		return
	fi
	inserted=1

	grep -q cal /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "insmodtest03: FAILED,cal not found in /proc/modules."
		touch result/insF03_2
		return
	fi

	tst_res TPASS "insmodtest03: PASSED"
	touch result/insP03

}

tst_run
