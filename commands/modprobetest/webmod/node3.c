#include <linux/module.h>
#include <linux/init.h>
MODULE_LICENSE("GPL");
int wadd(int a, int b);
int wsub(int a, int b);

int wsub1(int a, int b) {
     int ans=wsub(a,1);
     return ans*b;
}

static int  sym_init(void) {
    return 0;
}

static void  sym_exit(void) {

}

module_init(sym_init);
module_exit(sym_exit);

EXPORT_SYMBOL(wsub1);
