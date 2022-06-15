#!/bin/sh
pw=$(cat pw)
rootpos=$(cd `dirname $0`;pwd)

echo -e "\033[44;37m Cleancompilefile: 清除编译的全部文件 \033[0m"
cd testcases/commands/insmodtest
rm  cal.ko  cal.mod.c  cal.mod.o  cal.o
rm  usecal.ko  usecal.mod.c  usecal.mod.o  usecal.o
rm  Module.symvers modules.order

cd ../rmmodtest
rm  cal.ko  cal.mod.c  cal.mod.o  cal.o
rm  usecal.ko  usecal.mod.c  usecal.mod.o  usecal.o
rm  Module.symvers modules.order

cd ../lsmodtest
rm  cal.ko  cal.mod.c  cal.mod.o  cal.o
rm  usecal.ko  usecal.mod.c  usecal.mod.o  usecal.o
rm  Module.symvers modules.order

cd ../depmodtest
rm  cal.ko  cal.mod.c  cal.mod.o  cal.o
rm  usecal.ko  usecal.mod.c  usecal.mod.o  usecal.o
rm  Module.symvers modules.order
cd treemod
rm  tree1.ko  tree1.mod.c  tree1.mod.o  tree1.o
rm  tree2_1.ko  tree2_1.mod.c  tree2_1.mod.o  tree2_1.o
rm  tree2_2.ko  tree2_2.mod.c  tree2_2.mod.o  tree2_2.o
rm  tree3_1.ko  tree3_1.mod.c  tree3_1.mod.o  tree3_1.o
rm  tree3_2.ko  tree3_2.mod.c  tree3_2.mod.o  tree3_2.o
rm  tree3_4.ko  tree3_4.mod.c  tree3_4.mod.o  tree3_4.o
rm  Module.symvers modules.order
cd ../webmod
rm  node1.ko  node1.mod.c  node1.mod.o  node1.o
rm  node2.ko  node2.mod.c  node2.mod.o  node2.o
rm  node3.ko  node3.mod.c  node3.mod.o  node3.o
rm  node4.ko  node4.mod.c  node4.mod.o  node4.o
rm  node5.ko  node5.mod.c  node5.mod.o  node5.o
rm  Module.symvers modules.order

cd ../../modprobetest
rm  cal.ko  cal.mod.c  cal.mod.o  cal.o
rm  usecal.ko  usecal.mod.c  usecal.mod.o  usecal.o
rm  Module.symvers modules.order
cd treemod
rm  tree1.ko  tree1.mod.c  tree1.mod.o  tree1.o
rm  tree2_1.ko  tree2_1.mod.c  tree2_1.mod.o  tree2_1.o
rm  tree2_2.ko  tree2_2.mod.c  tree2_2.mod.o  tree2_2.o
rm  tree3_1.ko  tree3_1.mod.c  tree3_1.mod.o  tree3_1.o
rm  tree3_2.ko  tree3_2.mod.c  tree3_2.mod.o  tree3_2.o
rm  tree3_4.ko  tree3_4.mod.c  tree3_4.mod.o  tree3_4.o
rm  Module.symvers modules.order
cd ../webmod
rm  node1.ko  node1.mod.c  node1.mod.o  node1.o
rm  node2.ko  node2.mod.c  node2.mod.o  node2.o
rm  node3.ko  node3.mod.c  node3.mod.o  node3.o
rm  node4.ko  node4.mod.c  node4.mod.o  node4.o
rm  node5.ko  node5.mod.c  node5.mod.o  node5.o
rm  Module.symvers modules.order

cd $rootpos/testcases/kernel/syscalls/init_module/mod
rm    cal.mod.c  cal.mod.o  cal.o
rm    usecal.mod.c  usecal.mod.o  usecal.o
rm  Module.symvers modules.order
cd ..
rm cal.ko usecal.ko
rm init_module01 init_module02_07

cd ../delete_module/mod
rm    cal.mod.c  cal.mod.o  cal.o
rm    usecal.mod.c  usecal.mod.o  usecal.o
rm   Module.symvers modules.order
cd ..
rm cal.ko usecal.ko
rm delete_module01 delete_module02_06 delete_module07

echo -e "\033[44;37m Cleancompilefile:清除LSM测试所需的内核模块文件和测试程序的可执行文件 \033[0m"
cd $rootpos
cd testcases/lsm/lsmfile
rm  lsmf01.ko  lsmf01.mod.c  lsmf01.mod.o  lsmf01.o
rm  lsmf02.ko  lsmf02.mod.c  lsmf02.mod.o  lsmf02.o
rm  lsmf03.ko  lsmf03.mod.c  lsmf03.mod.o  lsmf03.o
rm  lsmf04.ko  lsmf04.mod.c  lsmf04.mod.o  lsmf04.o
rm  lsmf05.ko  lsmf05.mod.c  lsmf05.mod.o  lsmf05.o
rm  lsmf06.ko  lsmf06.mod.c  lsmf06.mod.o  lsmf06.o
rm  lsmf07.ko  lsmf07.mod.c  lsmf07.mod.o  lsmf07.o
rm  lsmf08.ko  lsmf08.mod.c  lsmf08.mod.o  lsmf08.o
rm  lsmf09.ko  lsmf09.mod.c  lsmf09.mod.o  lsmf09.o
rm  lsmf10.ko  lsmf10.mod.c  lsmf10.mod.o  lsmf10.o
rm  Module.symvers modules.order
touch LSMF.txt

cd ../lsmtask
rm  lsmt01.ko  lsmt01.mod.c  lsmt01.mod.o  lsmt01.o
rm  lsmt02.ko  lsmt02.mod.c  lsmt02.mod.o  lsmt02.o
rm  lsmt03.ko  lsmt03.mod.c  lsmt03.mod.o  lsmt03.o
rm  lsmt04.ko  lsmt04.mod.c  lsmt04.mod.o  lsmt04.o
rm taskfunc01 taskfunc02


cd ../lsmnetwork
rm  lsmn01.ko  lsmn01.mod.c  lsmn01.mod.o  lsmn01.o
echo -e "\033[44;37m Cleancompilefile:编译的全部文件清除完毕 \033[0m"
