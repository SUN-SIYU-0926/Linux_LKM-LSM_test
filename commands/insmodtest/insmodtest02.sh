#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: SunSiyu
#
# 内容：用insmod加载一个依赖于未加载模块的模块，若模块成功加载，则移除该模块。
# 期望结果：加载目标模块失败。

TST_CLEANUP=cleanup
TST_TESTFUNC=run
TST_NEEDS_ROOT=1
TST_NEEDS_CMDS="rmmod modprobe"
TST_NEEDS_MODULE="usecal.ko"
. tst_test.sh

inserted=0

cleanup()
{
	if [ $inserted -ne 0 ]; then
		tst_res TINFO "insmodtest02: running rmmod usecal"
		rmmod usecal.ko
		if [ $? -ne 0 ]; then
			tst_res TWARN "insmodtest02: failed to rmmod usecal"
		fi
		inserted=0
	fi
	echo ***************insmod_test02***************
}

run()
{
	insmod "$TST_MODPATH"
	
	if [ $? -ne 0 ]; then
		tst_res TPASS "insmodtest02: PASSED"
		touch result/insP02
		return
	else
		inserted=1
		tst_res TFAIL "insmodtest02: FAILED,Wrong load."
		touch result/insF02_1
		grep -q usecal /proc/modules
		if [ $? -ne 0 ]; then
			tst_res TINFO "insmodtest02: The dependency module is not loaded in /proc/modules"
			return
		fi
	fi

}

tst_run
