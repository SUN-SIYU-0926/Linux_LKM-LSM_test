obj-m := node1.o node2.o  node3.o node4.o node5.o                 #要生成的模块名      
	modules-objs:= node1.o node2.o  node3.o node4.o          #生成这个模块名所需要的目标文件

KDIR := /lib/modules/`uname -r`/build
	PWD := $(shell pwd)

default:
	make -C $(KDIR) M=$(PWD) modules

clean:
	rm -rf *.o .* .cmd *.ko
