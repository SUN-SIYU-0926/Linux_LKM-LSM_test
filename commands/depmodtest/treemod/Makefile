
obj-m := tree1.o tree2_1.o  tree2_2.o tree3_1.o tree3_2.o tree3_4.o                  #要生成的模块名      
	modules-objs:= tree1.o tree2_1.o  tree2_2.o tree3_1.o tree3_2.o tree3_4.o        #生成这个模块名所需要的目标文件

KDIR := /lib/modules/`uname -r`/build
	PWD := $(shell pwd)

default:
	make -C $(KDIR) M=$(PWD) modules

clean:
	rm -rf *.o *.ko
