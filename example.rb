$VERBOSE = true

require_relative 'lib/net/macaddress'

include Net

macaddr = MACAddress.parse('00-f1-11-02-07-9f')
p macaddr          #=> #<Net::MACAddress 00-f1-11-02-07-9f>
p macaddr.oui      #=> [#<Net::MACAddress::Octet 00: 00000000>, #<Net::MACAddress::Octet f1: 11110001>, #<Net::MACAddress::Octet 11: 00010001>]
p macaddr.globaly? #=> true
p macaddr.unicast? #=> true
