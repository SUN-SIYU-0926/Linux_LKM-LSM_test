#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: SunSiyu
#
# 内容:新增一组依赖模块在lib/modules下，depmod生成全部模块间的依赖关系
# 期望结果:depmod执行成功，新增的模块依赖被写入

TST_CLEANUP=cleanup
TST_SETUP=setup
TST_TESTFUNC=run
TST_NEEDS_TMPDIR=1
TST_NEEDS_CMDS="depmod"

modpath=/lib/modules/$(uname -r)/kernel
depfile=/lib/modules/$(uname -r)/modules.dep
nowpath=$(cd `dirname $0`;pwd)
. tst_test.sh

module_inserted=1
endt=0
cleanup()
{
	echo ***************depmod_test01***************
	if [ $endt -eq 1 ]; then
		return
	fi
	if [ "$module_inserted" = 1 ]; then
		tst_res TINFO "depmodtest01: delete information in modules.dep"
		mv $modpath/cal.ko $nowpath
		mv $modpath/usecal.ko $nowpath
		depmod
		if [ $? -ne 0 ]; then
			tst_res TWARN "depmodtest01: clean information failed ,try to run delko.sh"
		fi
	fi
}

setup(){
	mv $nowpath/cal.ko $modpath
	mv $nowpath/usecal.ko $modpath
	if [ $? -ne 0 ]; then
		tst_res TWARN "depmodtest01: FAILED,need modules"
		endt=1
		touch $nowpath/result/depE01_1
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
		tst_res TFAIL "depmodtest01: FAILED,lack of modules"
		touch $nowpath/result/depF01_1
	else
		grep "kernel/usecal.ko: kernel/cal.ko" /lib/modules/$(uname -r)/modules.dep
		if [ $? -ne 0 ]; then
			tst_res TFAIL "depmodtest01: FAILED,can not find module dependency"
			touch $nowpath/result/depF01_2
		else
			module_inserted=1
			tst_res TPASS "depmodtest01: PASSED"
			touch $nowpath/result/depP01
		fi
	fi
}

tst_run
