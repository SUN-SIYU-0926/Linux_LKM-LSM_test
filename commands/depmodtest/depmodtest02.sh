#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: SunSiyu
#
# 内容:新增一组依赖模块在lib/modules，depmod -A 仅生成新增模块的依赖关系
# 期望结果:命令较短时间内执行成功，新增模块依赖被写入


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
	echo ***************depmod_test02***************
	if [ $endt -eq 1 ]; then
		return
	fi
	if [ "$module_inserted" = 1 ]; then
		tst_res TINFO "depmodtest02: delete information in modules.dep"
		mv $modpath/cal.ko $nowpath
		mv $modpath/usecal.ko $nowpath
		depmod -A
		if [ $? -ne 0 ]; then
			tst_res TWARN "depmodtest02: clean information failed ,try to run delko.sh"
		fi
	fi
}

setup(){
	mv $nowpath/cal.ko /lib/modules/$(uname -r)/kernel
	mv $nowpath/usecal.ko /lib/modules/$(uname -r)/kernel
	if [ $? -ne 0 ]; then
		tst_res TWARN "depmodtest02: FAILED,need modules"
		endt=1
		touch $nowpath/result/depE02_1
	fi
}

run()
{
	tst_require_root
	if [ $endt -eq 1 ]; then
		return
	fi
	depmod -A
	if [ $? -ne 0 ]; then
		tst_res TFAIL "depmodtest02: FAILED,lack of modules"
		touch $nowpath/result/depF02_1
	else
		grep "kernel/usecal.ko: kernel/cal.ko" /lib/modules/$(uname -r)/modules.dep
		if [ $? -ne 0 ]; then
			tst_res TFAIL "depmodtest02: FAILED,can not find module dependency"
			touch $nowpath/result/depF02_2
		else
			module_inserted=1
			tst_res TPASS "depmodtest02: PASSED"
			touch $nowpath/result/depP02
		fi
	fi
}

tst_run
