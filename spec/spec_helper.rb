# coding: us-ascii
require 'rspec'

require_relative '../lib/net/macaddress'

module Net::MACAddress::RspecHelpers
end

RSpec.configure do |configuration|
  configuration.include Net::MACAddress::RspecHelpers
end
