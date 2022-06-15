#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: Sunsiyu
#
#内容:添加树型模块组的依赖关系，再使用modprobe直接加载其中一个模块
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
	echo ***************modprobe_test02***************
	if [ "$module_inserted" = 1 ]; then
		tst_res TINFO "modprobetest02: delete information in modules.dep"
		rmmod tree3_1.ko
		rmmod tree2_1.ko
		rmmod tree1.ko
	if [ $? -ne 0 ]; then
		tst_res TWARN "modprobetest02: failed to unload modules"
	fi
		mv $modpath/tree1.ko $nowpath/treemod
		mv $modpath/tree2_1.ko $nowpath/treemod
		mv $modpath/tree2_2.ko $nowpath/treemod
		mv $modpath/tree3_1.ko $nowpath/treemod
		mv $modpath/tree3_2.ko $nowpath/treemod
		mv $modpath/tree3_4.ko $nowpath/treemod
		depmod
		if [ $? -ne 0 ]; then
			tst_res TWARN "modprobetest02: failed to clean modules"
			$nowpath/back.sh
			return
		fi
		tst_res TINFO "modprobetest02: remove modules successfully"
	fi
}

setup(){
	mv $nowpath/treemod/tree1.ko $modpath
	mv $nowpath/treemod/tree2_1.ko $modpath
	mv $nowpath/treemod/tree2_2.ko $modpath
	mv $nowpath/treemod/tree3_1.ko $modpath
	mv $nowpath/treemod/tree3_2.ko $modpath
	mv $nowpath/treemod/tree3_4.ko $modpath
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest02: FAILED,can not move modules"
		endt=1
		touch $nowpath/result/modpE02_1
	fi
	tst_require_root	
	depmod
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest02: FAILED,failed to run depmod"
		endt=1
		touch $nowpath/result/modpE02_2
	else
		grep "tree3_1.ko: tree2_1.ko tree1.ko" $depfile
		if [ $? -ne 0 ]; then
			tst_res TFAIL "modprobetest02: FAILED,failed to find dependency records"
			endt=1
			touch $nowpath/result/modpE02_3
		fi
	fi
}

run()
{
	if [ $endt -eq 1 ]; then
		return 
	fi
	modprobe tree3_1
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest02: FAILED,can not run modprobe"
		touch $nowpath/result/modpF02_1
		return
	fi
	module_inserted=1
	grep -q tree1 /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest02: FAILED,cal not found tree1.ko in /proc/modules"
		touch $nowpath/result/modpF02_2
		return
	fi
	grep -q tree2_1 /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest02: FAILED,cal not found tree2_1.ko in /proc/modules"
		touch $nowpath/result/modpF02_3
		return
	fi
	grep -q tree3_1 /proc/modules
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest02: FAILED,cal not found tree3_1.ko in /proc/modules"
		touch $nowpath/result/modpF02_4
		return
	fi
	tst_res TPASS "modprobetest02: PASSED"
	touch $nowpath/result/modpP02

}

tst_run
