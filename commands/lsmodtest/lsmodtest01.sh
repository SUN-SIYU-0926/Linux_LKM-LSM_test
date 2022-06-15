#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Author: SunSiyu
#
# 内容：用rmmod卸载一个依赖于已加载模块的模块，若失败，按依赖移除模块。
# 期望结果：第一次卸载失败，第二次成功。

TST_CLEANUP=cleanup
TST_SETUP=setup
TST_TESTFUNC=run
TST_NEEDS_TMPDIR=1
TST_NEEDS_CMDS="lsmod"
NOWPATH=$(cd $(dirname $0);pwd)
. tst_test.sh

module_inserted=

setup()
{
	#NOWPATH=$(cd $(dirname $0);pwd)
	if [ -z "$(cat /proc/modules)"  ]; then
		tst_require_module "cal.ko"
		tst_require_root
		tst_require_cmds insmod
		ROD insmod "$TST_MODPATH"

		module_inserted=1
	fi
}

cleanup()
{
	echo ***************lsmod_test01***************
	if [ "$module_inserted" = 1 ]; then
		tst_res TINFO "lsmodtest01: Unloading dummy kernel module"
		rmmod cal
		if [ $? -ne 0 ]; then
			tst_res TWARN "lsmodtest01: rmmod failed"
		fi
	fi
}

lsmod_check()
{
	lsmod_output=$(lsmod \
			| awk '!/Module/{print $1, $2, ($3==-2) ? "-" : $3}' \
			| sort)
	if [ -z "$lsmod_output" ]; then
		tst_res TFAIL "lsmodtest01: Failed to parse the output from lsmod"
		touch "$NOWPATH"/result/lsmoF01_1
	fi

	modules_output=$(awk '{print $1, $2, $3}' /proc/modules | sort)
	if [ -z "$modules_output" ]; then
		tst_res TFAIL "lsmodtest01: Failed to parse /proc/modules"
		touch "$NOWPATH"/result/lsmoF01_2
	fi

	if [ "$lsmod_output" != "$modules_output" ]; then
		tst_res TINFO "lsmodtest01: lsmod output different from /proc/modules"

		echo "$lsmod_output" > temp1
		echo "$modules_output" > temp2
		if tst_cmd_available diff; then
			diff temp1 temp2
		else
			cat temp1 temp2
		fi

		return 1
	fi
	return 0
}

run()
{
	for i in $(seq 1 5); do
		if lsmod_check; then
			tst_res TPASS "lsmodtest01: PASSED"
			touch "$NOWPATH"/result/lsmoP01
			#touch 
			return
		fi
		tst_res TINFO "lsmodtest01: Trying again"
		sleep 1
	done
	tst_res TFAIL "lsmodtest01: FAILED,lsmod doesn't match /proc/modules output"
	touch "$NOWPATH"/result/lsmoF01_3
}

tst_run
