#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: SunSiyu
#
# 内容：用insmod加载一个不存在模块，若模块成功加载，则移除该模块。
# 期望结果：加载目标模块失败。

TST_CLEANUP=cleanup
TST_TESTFUNC=run
TST_NEEDS_ROOT=1
TST_NEEDS_CMDS="rmmod modprobe"
TST_NEEDS_MODULE="fake.ko"
. tst_test.sh

inserted=0

cleanup()
{
	if [ $inserted -ne 0 ]; then
		tst_res TINFO "insmodtest04: running rmmod usecal"
		rmmod fake.ko
		if [ $? -ne 0 ]; then
			tst_res TWARN "insmodtest04: failed to rmmod usecal"
		fi
		inserted=0
	fi
	echo ***************insmod_test04***************
}

run()
{
	insmod fake.ko
	
	if [ $? -ne 0 ]; then
		tst_res TPASS "insmodtest04: PASSED"
		touch result/insP04
		return
	fi
		inserted=1
		tst_res TFAIL "insmodtest04: FAILED,Wrong load."
		touch result/insF04_1
		grep -q usecal /proc/modules
		if [ $? -ne 0 ]; then
			tst_res TINFO "insmodtest04: The dependency module is not loaded in /proc/modules"
			return
		fi


}

tst_run
