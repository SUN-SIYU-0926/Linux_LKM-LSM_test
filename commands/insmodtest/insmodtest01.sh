#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: SunSiyu
#
# 内容：用insmod加载一个无依赖的模块,若模块成功加载，用将该模块移除。
# 期望结果：成功加载模块，成功移除模块。

TST_CLEANUP=cleanup
TST_TESTFUNC=run
TST_NEEDS_ROOT=1
TST_NEEDS_CMDS="rmmod insmod"
TST_NEEDS_MODULE="cal.ko"
. tst_test.sh

inserted=0

cleanup()
{
	if [ $inserted -ne 0 ]; then
		tst_res TINFO "insmodtest01: running rmmod cal"
		rmmod cal.ko
		if [ $? -ne 0 ]; then
			tst_res TWARN "insmodtest01: failed to rmmod cal"
		fi
		inserted=0
	fi
	echo ***************insmod_test01***************
}

run()
{
	insmod "$TST_MODPATH"
	if [ $? -ne 0 ]; then
		tst_res TFAIL "insmodtest01: FAILED,command failed to execute"
		touch result/insF01_1
		return
	fi
	inserted=1

	grep -q cal /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "insmodtest01: FAILED,cal not found in /proc/modules"
		touch result/insF01_2
		return
	fi

	tst_res TPASS "insmodtest01: PASSED"
	touch result/insP01
}

tst_run
