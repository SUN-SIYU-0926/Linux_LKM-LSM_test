#!/bin/bash
#create by SSY
#源文件所在目录
dirArray=( ./)
#最终存储的目录
aimDir=/lib/modules/$(uname -r)/kernel
#正则匹配表达式(可以直接写拷贝文件或指定格式)
regexA=cal.ko
regexB=usecal.ko
if [ ! -d $aimDir ]; then
  mkdir -p $aimDir
fi
for (( i=0;i<${#dirArray[@]};i++))
do
  fileArray=`find ${dirArray[i]} -name "$regexA"`
  fileArrayU=`find ${dirArray[i]} -name "$regexB"`
  for j in $fileArray
  do
    mv $j $aimDir
  done
  for l in $fileArrayU
  do
    #移动到目标目录
    mv $l $aimDir
  done
done

