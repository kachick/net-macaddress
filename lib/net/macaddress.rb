# Copyright (c) 2012 Kenichi Kamiya

require_relative 'macaddress/exceptions'
require_relative 'macaddress/octet'

module Net

  # Immutable
  class MACAddrress

    DELIMITER_PATTERN = /\A[:\-]\z/

    PATTERN = /\A(?:#{Octet::PATTERN}[:\-]){5}#{Octet::PATTERN}\z/

    class << self
      
      def parse(str)
        case str
        when PATTERN
          new str.split(DELIMITER_PATTERN).map{|oct|Octet.parse oct}
        else
          raise MalformedDataError
        end
      end
      
    end

    # @param octets [Array<Octet>] - [Octet * 6]
    def initialize(octets)
      raise TypeError unless octets.length == 6 and octets.all?{|o|o.kind_of? Octet}

      @octets = octets.dup.freeze
    end

    def octets
      @octets.dup
    end

    def oui
      @octets.take 3
    end

    def nic
      @octets.drop 3
    end

    def unicast?
      self[1][1] == 0
    end

    def multicast?
      self[1][1] == 1
    end

    def globaly?
      self[1][2] == 0
    end

    def localy?
      self[1][2] == 1
    end
    
    def to_s(delimiter='-')
      format_octets @octets, delimiter
    end

    def inspect
      "#<MACAddress: #{to_s}>"
    end

    def ==(other)
     self.class == other.class && octets == other.octets
    end

    def hash
      @octets.hash
    end

    def eql?(other)
      self.class.eql?(other.class) && octets.eql?(other.octets)
    end
    
    # RFC3768
    def vrrp?
      format_octets(@octets.take(5), '-') == '00-00-5e-00-01'
    end
    
    private

    # @param offset [Fixnum] 1..6
    def [](offset)
      @octets[offset - 1]
    end

    def format_octets(octets, delimiter)
      octets.map(&:to_s).join delimiter
    end

  end

end
