#include <linux/module.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");

int add(int a, int b) {
     return a+b;
}

int sub(int a, int b) {
    return a-b;
}

static int  sym_init(void) {
    return 0;
}

static void  sym_exit(void) {

}

module_init(sym_init);
module_exit(sym_exit);

EXPORT_SYMBOL(add);
EXPORT_SYMBOL(sub);
