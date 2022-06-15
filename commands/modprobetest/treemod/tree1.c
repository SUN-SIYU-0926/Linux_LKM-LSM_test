#include <linux/module.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");

int tadd(int a, int b) {
     return a+b;
}

int tsub(int a, int b) {
    return a-b;
}

static int  sym_init(void) {
    return 0;
}

static void  sym_exit(void) {

}

module_init(sym_init);
module_exit(sym_exit);

EXPORT_SYMBOL(tadd);
EXPORT_SYMBOL(tsub);
