##
# This module requires Metasploit: http//metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'

class Metasploit3 < Msf::Auxiliary
  include Msf::Exploit::Remote::Udp
  include Msf::Auxiliary::Report
  include Msf::Auxiliary::UDPScanner
  include Msf::Exploit::Remote::SIP

  def initialize
    super(
      'Name'        => 'SIP Endpoint Scanner (UDP)',
      'Description' => 'Scan for SIP devices using OPTIONS requests',
      'Author'      => 'hdm',
      'License'     => MSF_LICENSE
    )

    register_options(
    [
      OptString.new('TO',   [false, 'The destination username to probe at each host', 'nobody']),
      Opt::RPORT(5060)
    ], self.class)
  end

  def scanner_prescan(batch)
    print_status("Sending SIP UDP OPTIONS requests to #{batch[0]}->#{batch[-1]} (#{batch.length} hosts)")
    @res = {}
  end

  def scan_host(ip)
    scanner_send(create_probe(ip, 'udp'), ip, datastore['RPORT'])
  end

  def scanner_process(data, shost, _)
    parse_response(data, shost, 'udp')
  end
end
