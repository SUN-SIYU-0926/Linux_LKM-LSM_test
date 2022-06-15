#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: Sunsiyu
#
#内容:添加网状模块组的依赖关系，再使用modprobe直接加载其中一个模块
#期望:被加载模块引用的模块全部加载到内核


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
	echo ***************modprobe_test03***************
#	if [ "$module_inserted" = 1 ]; then
		tst_res TINFO "modprobetest03: delete information in modules.dep"
		rmmod node5.ko
		rmmod node4.ko
		rmmod node3.ko
		rmmod node2.ko
		rmmod node1.ko
		if [ $? -ne 0 ]; then
			tst_res TWARN "modprobetest03: failed to unload modules"
		fi
		mv $modpath/node1.ko $nowpath/webmod
		mv $modpath/node2.ko $nowpath/webmod
		mv $modpath/node3.ko $nowpath/webmod
		mv $modpath/node4.ko $nowpath/webmod
		mv $modpath/node5.ko $nowpath/webmod
		depmod
		if [ $? -ne 0 ]; then
			tst_res TWARN "modprobetest03: failed to clean modules"
			$nowpath/back.sh
			return
		fi
		tst_res TINFO "modprobetest03: remove modules successfully"
#	fi
	
	
}

setup(){
	mv $nowpath/webmod/node1.ko $modpath
	mv $nowpath/webmod/node2.ko $modpath
	mv $nowpath/webmod/node3.ko $modpath
	mv $nowpath/webmod/node4.ko $modpath
	mv $nowpath/webmod/node5.ko $modpath
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest03: FAILED,can not move modules"
		endt=1
		touch $nowpath/result/modpE03_1
	fi
	tst_require_root	
	depmod
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest03: FAILED,failed to run depmod"
		endt=1
		touch $nowpath/result/modpE03_2
	else
		grep "node5.ko: node4.ko node2.ko node3.ko node1.ko" $depfile
		if [ $? -ne 0 ]; then
			tst_res TFAIL "modprobetest03: FAILED,failed to find dependency records"
			endt=1
			touch $nowpath/result/modpE03_3
		fi
	fi
}
run()
{
	if [ $endt -eq 1 ]; then
		return 
	fi
	modprobe node5
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest03: FAILED,can not run modprobe"
		touch $nowpath/result/modpF03_1
		return
	fi
	module_inserted=1
	grep -q node1 /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest03: FAILED,cal not found node1.ko in /proc/modules"
		touch $nowpath/result/modpF03_2
		return
	fi
	grep -q node2 /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest03: FAILED,cal not found node2.ko in /proc/modules"
		touch $nowpath/result/modpF03_3
		return
	fi
	grep -q node3 /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest03: FAILED,cal not found node3.ko in /proc/modules"
		touch $nowpath/result/modpF03_4
		return
	fi
	grep -q node4 /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest03: FAILED,cal not found node4.ko in /proc/modules"
		touch $nowpath/result/modpF03_5
		return
	fi
	tst_res TPASS "modprobetest03: PASSED"
	touch $nowpath/result/modpP03

}

tst_run
