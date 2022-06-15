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
t1=webmod/node1.ko
t2=webmod/node2.ko
t3=webmod/node3.ko
t4=webmod/node4.ko
t5=webmod/node5.ko
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
	echo ***************depmod_test04***************
	if [ $endt -eq 1 ]; then
		return
	fi
	if [ "$module_inserted" = 1 ]; then
		tst_res TINFO "depmodtest04: delete information in modules.dep"
		mv $modpath/node1.ko $nowpath/webmod
		mv $modpath/node2.ko $nowpath/webmod
		mv $modpath/node3.ko $nowpath/webmod
		mv $modpath/node4.ko $nowpath/webmod
		mv $modpath/node5.ko $nowpath/webmod
		depmod 
		if [ $? -ne 0 ]; then
			tst_res TWARN "depmodtest04: clean information failed ,try to run back.sh and restart"
			$nowpath/webmod/back.sh
			depmod 
		fi
	fi
}

setup(){
	#cd treemod
	echo $nowpath
	mv $nowpath/$t1 $modpath
	mv $nowpath/$t2 $modpath
	mv $nowpath/$t3 $modpath
	mv $nowpath/$t4 $modpath
	mv $nowpath/$t5 $modpath
	if [ $? -ne 0 ]; then
		tst_res TWARN "depmodtest04: FAILED,can not move modules"
		endt=1
		touch $nowpath/result/depE04_1
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
		tst_res TFAIL "depmodtest04: FAILED,lack of modules"
		touch $nowpath/result/depF04_1
	else
	#search modules.dep
	#ji de xie 
	grep "kernel/node1.ko:" $depfile
		if [ $? -eq 0 ]; then
			r1=1
		else
			tst_res TFAIL "depmodtest04: FAILED,dependency records of node1.ko are incomplete"
			touch $nowpath/result/depF04_2
		fi
	grep "kernel/node2.ko: kernel/node1.ko" $depfile
		if [ $? -eq 0 ]; then
			r2_2=1
		else
			tst_res TFAIL "depmodtest04: FAILED,dependency records of node2.ko are incomplete"
			touch $nowpath/result/depF04_3
		fi
	grep "kernel/node3.ko: kernel/node1.ko" $depfile
		if [ $? -eq 0 ]; then
			r2_1=1
		else
			tst_res TFAIL "depmodtest04: FAILED,dependency records of node3.ko are incomplete"
			touch $nowpath/result/depF04_4
		fi
	grep "kernel/node4.ko: kernel/node2.ko kernel/node3.ko kernel/node1.ko" $depfile
		if [ $? -eq 0 ]; then
			r3_4=1
		else
			tst_res TFAIL "depmodtest04: FAILED,dependency records of node4.ko are incomplete"
			touch $nowpath/result/depF04_5
		fi
	grep "kernel/node5.ko: kernel/node4.ko kernel/node2.ko kernel/node3.ko kernel/node1.ko" $depfile
		if [ $? -eq 0 ]; then
			r3_1=1
		else
			tst_res TFAIL "depmodtest04: FAILED,dependency records of node5.ko are incomplete"
			touch $nowpath/result/depF04_6
		fi

		tst_res TPASS "depmodtest03: PASSED"
		touch $nowpath/result/depP04
	fi
}

tst_run
