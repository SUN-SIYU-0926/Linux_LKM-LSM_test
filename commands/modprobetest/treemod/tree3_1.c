#include <linux/module.h>
#include <linux/init.h>
MODULE_LICENSE("GPL");
int tadd1(int a, int b);

int tadd2(int a, int b) {
     int ans=tadd1(a,1);
     return ans*b;
}

static int  sym_init(void) {
    return 0;
}

static void  sym_exit(void) {

}

module_init(sym_init);
module_exit(sym_exit);

EXPORT_SYMBOL(tadd2);
