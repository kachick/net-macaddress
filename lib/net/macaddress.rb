# Copyright (c) 2012 Kenichi Kamiya

require_relative 'macaddress/exceptions'
require_relative 'macaddress/octet'

module Net

  # Immutable
  class MACAddress

    DELIMITER_PATTERN = /[:\-]/

    PATTERN = /\A(?:#{Octet::PATTERN_STR}[:\-]){5}#{Octet::PATTERN_STR}\z/
    
    p PATTERN

    class << self
      
      def parse(str)
        raise MalformedDataError unless PATTERN.match str
        
        new str.split(DELIMITER_PATTERN).map{|oct|Octet.parse oct}
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
    
    alias_method :company_id, :oui

    def extension_id
      @octets.drop 3
    end
    
    alias_method :ei, :extension_id
    
    def individual_group_bit
      self[1][1]
    end
    
    alias_method :ig_bit, :individual_group_bit
    
    def universal_local_bit
      self[1][2]
    end
    
    alias_method :ui_bit, :universal_local_bit

    def unicast?
      individual_group_bit == 0
    end

    def multicast?
      individual_group_bit == 1
    end

    def globaly?
      universal_local_bit == 0
    end

    def localy?
      universal_local_bit == 1
    end
    
    def to_s(delimiter='-')
      format_octets @octets, delimiter
    end

    def inspect
      "#<#{self.class} #{to_s}>"
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
