#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: SunSiyu
#
# 内容：rmmod卸载一个无依赖模块。
# 期望结果：卸载目标模块成功。

TST_CLEANUP=cleanup
TST_TESTFUNC=run
TST_SETUP=setup
TST_NEEDS_ROOT=1
TST_NEEDS_CMDS="rmmod insmod"
TST_NEEDS_MODULE="cal.ko"
endt=0
. tst_test.sh

inserted=0

cleanup()
{
	echo ***************rmmod_test01***************
}

setup()
{
	insmod cal.ko
	if [ $? -ne 0 ]; then
		endt=1
		tst_res TWARN "rmmodtest01: failed to prepare cal.ko for test03"
		touch result/rmmE01_1
	fi
	
}

run()
{
	if [ $endt -eq 1 ] ; then
		return 
	fi
	rmmod cal.ko
	if [ $? -ne 0 ]; then
		tst_res TFAIL "rmmodtest01: FAILED,command failed to execute."
		touch result/rmmF01_1
		return
	fi

	grep -q cal /proc/modules
	if [ $? -eq 0 ]; then
		tst_res TFAIL "rmmodtest01: FAILED,remove cal.ko failed."
		touch result/rmmF01_2
		return
	fi

	tst_res TPASS "rmmodtest01: PASSED"
	touch result/rmmP01

}

tst_run
