#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: Sunsiyu
#
#内容:先添加模块的依赖关系，再使用modprobe直接加载引用了其他模块的模块
#期望:两个模块加载成功
TST_CLEANUP=cleanup
TST_SETUP=setup
TST_TESTFUNC=run
TST_NEEDS_TMPDIR=1
TST_NEEDS_CMDS="depmod"
modpath=/lib/modules/$(uname -r)
depfile=/lib/modules/$(uname -r)/modules.dep
nowpath=$(cd `dirname $0`;pwd)
endt=0
. tst_test.sh

module_inserted=0
cleanup()
{
	echo ***************modprobe_test01***************
	if [ "$module_inserted" = 1 ]; then
		tst_res TINFO "modprobetest01: delete information in modules.dep"
		rmmod usecal
		rmmod cal
	if [ $? -ne 0 ]; then
		tst_res TWARN "modprobetest01: failed to unload modules"
	fi
		mv $modpath/cal.ko $nowpath
		mv $modpath/usecal.ko $nowpath
		depmod
		if [ $? -ne 0 ]; then
			tst_res TWARN "modprobetest01: failed to clean modules"
			$nowpath/back.sh
			return
		fi
		tst_res TINFO "modprobetest01: remove modules successfully"
	fi
}

setup(){
	mv $nowpath/cal.ko $modpath
	mv $nowpath/usecal.ko $modpath
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest01: FAILED,can not move modules"
		endt=1
		touch $nowpath/result/modpE01_1
	fi	
	depmod
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest01: FAILED,failed to run depmod"
		endt=1
		touch $nowpath/result/modpE01_2
	else
		grep "usecal.ko: cal.ko" $depfile
		if [ $? -ne 0 ]; then
			tst_res TFAIL "modprobetest01: FAILED,failed to add dependency records"
			endt=1
			touch $nowpath/result/modpE01_3
		fi
	fi
}
run()
{
	if [ $endt -eq 1 ]; then
		return 
	fi
	modprobe usecal
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest01: FAILED,can not run modprobe"
		touch $nowpath/result/modpF01_1
		return
	fi
	module_inserted=1
	grep -q cal /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest01: FAILED,cal not found cal.ko in /proc/modules"
		touch $nowpath/result/modpF01_2
		return
	fi
	grep -q usecal /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest01: FAILED,cal not found usecal.ko in /proc/modules"
		touch $nowpath/result/modpF01_3
		return
	fi
	tst_res TPASS "modprobetest01: PASSED"
	touch $nowpath/result/modpP01

}

tst_run
