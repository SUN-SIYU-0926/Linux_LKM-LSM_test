#!/bin/sh
pw=$(cat pw)
rootpos=$(cd `dirname $0`;pwd)

echo -e "\033[37;42m Createfile:生成LKM测试所需的内核模块文件和测试程序的可执行文件 \033[0m"
cd testcases/commands/insmodtest
make
chmod 777 cal.ko usecal.ko
chmod 777 insmodtest01.sh insmodtest02.sh insmodtest03.sh insmodtest04.sh

cd ../rmmodtest
make
chmod 777 cal.ko usecal.ko
chmod 777 rmmodtest01.sh rmmodtest02.sh

cd ../lsmodtest
make
chmod 777 cal.ko usecal.ko
chmod 777 lsmodtest01.sh

cd ../depmodtest
make
chmod 777 cal.ko usecal.ko
chmod 777 depmodtest01.sh depmodtest02.sh depmodtest03.sh depmodtest04.sh
cd treemod
make
chmod 777 tree1.ko tree2_1.ko tree2_2.ko tree3_1.ko tree3_2.ko tree3_4.ko
cd ../webmod
make
chmod 777 node1.ko node2.ko node3.ko node4.ko node5.ko

cd ../../modprobetest
make
chmod 777 cal.ko usecal.ko
chmod 777 modprobetest01.sh modprobetest02.sh modprobetest03.sh modprobetest04.sh modprobetest05.sh
cd treemod
make
chmod 777 tree1.ko tree2_1.ko tree2_2.ko tree3_1.ko tree3_2.ko tree3_4.ko
cd ../webmod
make
chmod 777 node1.ko node2.ko node3.ko node4.ko node5.ko

cd ../../../kernel/syscalls/init_module/mod
make
chmod 777 cal.ko usecal.ko
cd ..
mv mod/cal.ko ./
mv mod/usecal.ko ./

make
chmod 777 init_module01 init_module02_07

cd ../delete_module/mod
make
chmod 777 cal.ko usecal.ko
cd ..
mv mod/cal.ko ./
mv mod/usecal.ko ./
make
chmod 777 delete_module01 delete_module02_06 delete_module07

echo -e "\033[37;42m Createfile:生成LSM测试所需的内核模块文件和测试程序的可执行文件 \033[0m"
cd $rootpos
cd testcases/lsm/lsmfile
make
touch LSMF.txt
chmod 777 lsmf01.ko lsmf04.ko lsmf05.ko lsmf07.ko lsmf08.ko lsmf10.ko

cd ../lsmtask
make
chmod 777 lsmt01.ko lsmt03.ko lsmt04.ko
cd testf
make
chmod 777 taskfunc01 taskfunc02
mv taskfunc01 ../
mv taskfunc02 ../
cd ..

cd ../lsmnetwork
make
chmod 777 lsmn01.ko
echo -e "\033[37;42m Createfile:准备文件生成完毕，可以尝试运行测试启动脚本 \033[0m"

