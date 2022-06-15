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
needcl=0
. tst_test.sh

module_inserted=0

cleanup()
{
	echo ***************modprobe_test05***************
	if [ "$needcl" = 1 ]; then
		rmmod $modpath/node5.ko
		rmmod $modpath/node4.ko
		rmmod $modpath/node3.ko
		rmmod $modpath/node2.ko
		rmmod $modpath/node1.ko
	fi
		tst_res TINFO "modprobetest05: delete information in modules.dep"
		mv $modpath/node1.ko $nowpath/webmod
		mv $modpath/node2.ko $nowpath/webmod
		mv $modpath/node3.ko $nowpath/webmod
		mv $modpath/node4.ko $nowpath/webmod
		mv $modpath/node5.ko $nowpath/webmod
		depmod
		if [ $? -ne 0 ]; then
			tst_res TWARN "modprobetest05: failed to clean modules"
			$nowpath/back.sh
			return
		fi
		depmod
		tst_res TINFO "modprobetest05: remove modules successfully"
}

setup()
{
	mv $nowpath/webmod/node1.ko $modpath
	mv $nowpath/webmod/node2.ko $modpath
	mv $nowpath/webmod/node3.ko $modpath
	mv $nowpath/webmod/node4.ko $modpath
	mv $nowpath/webmod/node5.ko $modpath
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest05: FAILED,can not move modules"
		endt=1
		touch $nowpath/result/modpE05_1
		return 
	fi
	depmod 
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest05: FAILED,FAILED,failed to run depmod"
		endt=1
		touch $nowpath/result/modpE05_2
		return 
	fi
	modprobe node5
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest05: FAILED,failed to load module group"
		endt=1
		touch $nowpath/result/modpE05_3
		return 
	fi
}

run()
{
	modprobe -r node5 
	if [ $? -ne 0 ]; then
		tst_res TFAIL "modprobetest05: FAILED,the dependency between node1.ko and node5.ko is lost"
		endt=1
		touch $nowpath/result/modpF05_1
		return 
	fi
	grep -q node5 /proc/modules
	if [ $? -eq 0 ]; then
		tst_res TFAIL "modprobetest05: FAILED,unload node5.ko failed."
		needcl=1
		touch $nowpath/result/modpF05_2
		return
	fi
	grep -q node4 /proc/modules
	if [ $? -eq 0 ]; then
		tst_res TFAIL "modprobetest05: FAILED,unload node4.ko failed."
		needcl=1
		touch $nowpath/result/modpF05_3
		return 
	fi
	grep -q node3 /proc/modules
	if [ $? -eq 0 ]; then
		tst_res TFAIL "modprobetest05: FAILED,unload node3.ko failed."
		needcl=1
		touch $nowpath/result/modpF05_4
		return 
	fi
	grep -q node2 /proc/modules
	if [ $? -eq 0 ]; then
		tst_res TFAIL "modprobetest05: FAILED,unload node2.ko failed."
		needcl=1
		touch $nowpath/result/modpF05_5
		return 
	fi
	grep -q node1 /proc/modules
	if [ $? -eq 0 ]; then
		tst_res TFAIL "modprobetest05: FAILED,unload node1 failed."
		needcl=1
		touch $nowpath/result/modpF05_6
		return 
	fi
	tst_res TPASS "modprobetest05:PASSED"
	touch $nowpath/result/modpP05
}

tst_run
