#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: SunSiyu
#
# 内容：用rmmod卸载一个依赖于已加载模块的模块，若失败，按依赖移除模块。
# 期望结果：第一次卸载失败，第二次成功。

TST_CLEANUP=cleanup
TST_TESTFUNC=run
TST_SETUP=setup
TST_NEEDS_ROOT=1
TST_NEEDS_CMDS="rmmod insmod"
TST_NEEDS_MODULE="cal.ko"
endt=0
endt2=0
. tst_test.sh

inserted=0

cleanup()
{
	if [ $endt2 -eq 0 ] ; then
		rmmod usecal.ko
		if [ $? -ne 0 ]; then
			tst_res TWARN "rmmodtest02: failed to remove usecal.ko"
			touch result/rmmF02_3
		fi
		if  [ $endt -eq 0 ] ; then
			rmmod cal.ko
			if [ $? -ne 0 ]; then
				tst_res TWARN "rmmodtest02: failed to remove cal.ko"
				touch result/rmmF02_4
			fi
		fi
		
	fi
	echo ***************rmmod_test02***************
}

setup()
{
	insmod cal.ko
	if [ $? -ne 0 ]; then
		endt=1
		tst_res TWARN "rmmodtest02: failed to prepare cal.ko for test03"
		touch result/rmmE02_1
	fi
	insmod usecal.ko
	if [ $? -ne 0 ]; then
		endt2=1
		tst_res TWARN "rmmodtest02: failed to prepare usecal.ko for test03"
		touch result/rmmE02_2
	fi
}

run()
{
	if [ $endt -eq 1 ] ; then
		return 
	fi
	rmmod cal.ko
	if [ $? -eq 0 ]; then
		tst_res TFAIL "rmmodtest02: FAILED,unsafe to remove the module"
		touch result/rmmF02_1
		return
	fi

	grep -q usecal /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "rmmodtest02: FAILED,usecal not found in /proc/modules"
		touch result/rmmF02_2
		return
	fi

	tst_res TPASS "rmmodtest02: PASSED"
	touch result/rmmP02

}

tst_run
