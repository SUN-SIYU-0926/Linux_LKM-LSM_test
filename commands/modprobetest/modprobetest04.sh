#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: Sunsiyu
#
#内容:移动一组网状模块到/lib/modules下，modprobe -D查看某个模块的依赖关系
#期望:搜索到模块全部依赖关系


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
	echo ***************modprobe_test04***************
#	if [ "$module_inserted" = 1 ]; then
		tst_res TINFO "modprobetest04: delete information in modules.dep"
		mv $modpath/node1.ko $nowpath/webmod
		mv $modpath/node2.ko $nowpath/webmod
		mv $modpath/node3.ko $nowpath/webmod
		mv $modpath/node4.ko $nowpath/webmod
		mv $modpath/node5.ko $nowpath/webmod
		depmod
		if [ $? -ne 0 ]; then
			tst_res TWARN "modprobetest04: failed to clean modules"
			$nowpath/back.sh
			return
		fi
		depmod
		tst_res TINFO "modprobetest04: remove modules successfully"
#	fi
}

setup()
{
	mv $nowpath/webmod/node1.ko $modpath
	mv $nowpath/webmod/node2.ko $modpath
	mv $nowpath/webmod/node3.ko $modpath
	mv $nowpath/webmod/node4.ko $modpath
	mv $nowpath/webmod/node5.ko $modpath
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest04: FAILED,can not move modules"
		endt=1
		touch $nowpath/result/modpE04_1
		return 
	fi
	depmod
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest04: FAILED,failed to run depmod"
		endt=1
		touch $nowpath/result/modpE04_2
		return 
	else
		grep "node5.ko: node4.ko node2.ko node3.ko node1.ko" $depfile
		if [ $? -ne 0 ]; then
			tst_res TFAIL "modprobetest04: FAILED,failed to find dependency records"
			endt=1
			touch $nowpath/result/modpE04_3
			return 
		fi
	fi
}

run()
{
	modprobe -D node5 | grep "insmod /lib/modules/4.4.297/node1.ko"
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest04: FAILED,the dependency between node1.ko and node5.ko is lost"
		endt=1
		touch $nowpath/result/modpF04_1
		return 
	fi
	modprobe -D node5 | grep "insmod /lib/modules/4.4.297/node2.ko"
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest04: FAILED,the dependency between node2.ko and node5.ko is lost"
		endt=1
		touch $nowpath/result/modpF04_2
		return 
	fi
	modprobe -D node5 | grep "insmod /lib/modules/4.4.297/node3.ko"
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest04: FAILED,the dependency between node3.ko and node5.ko is lost"
		endt=1
		touch $nowpath/result/modpF04_3
		return 
	fi
	modprobe -D node5 | grep "insmod /lib/modules/4.4.297/node4.ko"
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest04: FAILED,the dependency between node4.ko and node5.ko is lost"
		endt=1
		touch $nowpath/result/modpF04_4
		return 
	fi
	tst_res TPASS "modprobetest04: PASSED"
	touch $nowpath/result/modpP04
}

tst_run
