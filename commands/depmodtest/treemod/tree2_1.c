#include <linux/module.h>
#include <linux/init.h>
MODULE_LICENSE("GPL");
int add(int a, int b);
int sub(int a, int b);

int add1(int a,int b) {
     int ans=add(a,1);
     return ans+b;
}

static int  sym_init(void) {
    return 0;
}

static void  sym_exit(void) {

}

module_init(sym_init);
module_exit(sym_exit);

EXPORT_SYMBOL(add1);
