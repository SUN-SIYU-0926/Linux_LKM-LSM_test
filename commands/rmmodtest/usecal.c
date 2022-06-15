#include <linux/module.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Sun");
MODULE_DESCRIPTION("Hello World Module");
MODULE_ALIAS("a simplest module");

static int age = 10;
module_param(age, int, S_IRUGO);//allow all user to use this param

int add(int a, int b);
int sub(int a, int b);

static int hello_init(void)
{
    printk("<0>"" Hello World! age = %d\n", add(10, 20));//调用内核模块cal.ko里面的add函数
    return 0;
}

static void  hello_exit(void)
{
    printk("<0>""hello exit %d\n", sub(30,10));//调用内核模块cal.ko里面的sub函数

}

module_init(hello_init);
module_exit(hello_exit);
