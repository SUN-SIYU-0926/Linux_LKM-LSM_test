#!/bin/sh
pw=$(cat pw)
rootpos=$(cd `dirname $0`;pwd)

echo -e "\033[44;37m Cleancompilefile: 清除结果的全部文件 \033[0m"
cd testcases/commands/insmodtest
rm -rf result
mkdir result

cd ../rmmodtest
rm -rf result
mkdir result

cd ../lsmodtest
rm -rf result
mkdir result

cd ../depmodtest
rm -rf result
mkdir result

cd ../modprobetest
rm -rf result
mkdir result

cd $rootpos/testcases/kernel/syscalls/init_module
rm -rf result
mkdir result

cd ../delete_module
rm -rf result
mkdir result


cd $rootpos
cd testcases/lsm/lsmfile
rm -rf result
mkdir result
touch LSMF.txt

cd ../lsmtask
rm -rf result
mkdir result


cd ../lsmnetwork
rm -rf result
mkdir result
echo -e "\033[44;37m Createfile:文件清除完毕 \033[0m"
