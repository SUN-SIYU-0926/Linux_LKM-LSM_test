#include <linux/module.h>
#include <linux/init.h>
MODULE_LICENSE("GPL");
int add1(int a, int b);
int sub1(int a, int b);
int equal(int a, int b);

int func(int a, int b) {
     int ans=sub1(a,1);
     ans=add1(ans,1);
     ans=equal(ans,b);
     return ans+b;
}

static int  sym_init(void) {
    return 0;
}

static void  sym_exit(void) {

}

module_init(sym_init);
module_exit(sym_exit);

EXPORT_SYMBOL(func);
