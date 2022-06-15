#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: SunSiyu
#
# 内容:新增一组依赖关系呈树形的模块，并depmod -A生成模块依赖关系
# 期望:成功在依赖文件中添加树形模块组的依赖关系


TST_CLEANUP=cleanup
TST_SETUP=setup
TST_TESTFUNC=run
TST_NEEDS_TMPDIR=1
TST_NEEDS_CMDS="depmod"
t1=treemod/tree1.ko
t2_1=treemod/tree2_1.ko
t2_2=treemod/tree2_2.ko
t3_1=treemod/tree3_1.ko
t3_2=treemod/tree3_2.ko
t3_4=treemod/tree3_4.ko
modpath=/lib/modules/$(uname -r)/kernel
depfile=/lib/modules/$(uname -r)/modules.dep
nowpath=$(cd `dirname $0`;pwd)
r1=0
r2_1=0
r2_2=0
r3_1=0
r3_2=0
r3_4=0
. tst_test.sh

module_inserted=1
endt=0
cleanup()
{
	echo ***************depmod_test03***************
	if [ $endt -eq 1 ]; then
		return
	fi
	if [ "$module_inserted" = 1 ]; then
		tst_res TINFO "depmodtest03: delete information in modules.dep"
		mv $modpath/tree1.ko $nowpath/treemod
		mv $modpath/tree2_1.ko $nowpath/treemod
		mv $modpath/tree2_2.ko $nowpath/treemod
		mv $modpath/tree3_1.ko $nowpath/treemod
		mv $modpath/tree3_2.ko $nowpath/treemod
		mv $modpath/tree3_4.ko $nowpath/treemod
		depmod 
		if [ $? -ne 0 ]; then
			tst_res TWARN "depmodtest03: clean information failed ,try to run back.sh and restart"
			$nowpath/treemod/back.sh
			depmod 
		fi
	fi
}

setup(){
	#cd treemod
	echo $nowpath
	mv $nowpath/$t1 $modpath
	mv $nowpath/$t2_1 $modpath
	mv $nowpath/$t2_2 $modpath
	mv $nowpath/$t3_1 $modpath
	mv $nowpath/$t3_2 $modpath
	mv $nowpath/$t3_4 $modpath
	if [ $? -ne 0 ]; then
		tst_res TWARN "depmodtest03: FAILED,can not move modules"
		endt=1
		touch $nowpath/result/depE03_1
	fi
}

run()
{
	tst_require_root
	if [ $endt -eq 1 ]; then
		return
	fi
	depmod 
	if [ $? -ne 0 ]; then
		tst_res TFAIL "depmodtest03: FAILED,lack of modules"
		touch $nowpath/result/depF03_1
	else
	#search modules.dep
	#ji de xie 
	grep "kernel/tree1.ko:" $depfile
		if [ $? -eq 0 ]; then
			r1=1
		else
			tst_res TFAIL "depmodtest03: FAILED,dependency records of tree1.ko are incomplete"
		fi
	grep "kernel/tree2_2.ko: kernel/tree1.ko" $depfile
		if [ $? -eq 0 ]; then
			r2_2=1
		else
			tst_res TFAIL "depmodtest03: FAILED,dependency records of tree2_2.ko are incomplete"
		fi
	grep "kernel/tree2_1.ko: kernel/tree1.ko" $depfile
		if [ $? -eq 0 ]; then
			r2_1=1
		else
			tst_res TFAIL "depmodtest03: FAILED,dependency records of tree2_1.ko are incomplete"
		fi
	grep "kernel/tree3_4.ko: kernel/tree2_2.ko kernel/tree1.ko" $depfile
		if [ $? -eq 0 ]; then
			r3_4=1
		else
			tst_res TFAIL "depmodtest03: FAILED,dependency records of tree3_4.ko are incomplete"
		fi
	grep "kernel/tree3_2.ko: kernel/tree2_1.ko kernel/tree1.ko" $depfile
		if [ $? -eq 0 ]; then
			r3_2=1
		else
			tst_res TFAIL "depmodtest03: FAILED,dependency records of tree3_2.ko are incomplete"
		fi
	grep "kernel/tree3_1.ko: kernel/tree2_1.ko kernel/tree1.ko" $depfile
		if [ $? -eq 0 ]; then
			r3_1=1
		else
			tst_res TFAIL "depmodtest03: FAILED,dependency records of tree3_1.ko are incomplete"
		fi
	#if [ $r1 -ne 6 ]; then
		#tst_res TFAIL "depmodtest03: FAILED,dependency records are incomplete"
		#touch $nowpath/result/depF03_2
		#return 
	#fi
		tst_res TPASS "depmodtest03: PASSED"
		touch $nowpath/result/depP03
	fi
}

tst_run
