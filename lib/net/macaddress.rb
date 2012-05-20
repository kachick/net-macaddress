$VERBOSE = true

module Net
  
  # Immutable
  class MACAddrress

    class MalformedDataError < StandardError; end

    # Immutable
    class Octet

      RADIXIES = [128, 64, 32, 16, 8, 3, 2, 1].freeze
      DEF_BIT = {0 => 0, 1 => 1, true => 1, false => 0}.freeze
      
      def initialize(bits)
        raise ArgumentError unless bits.length == 8
        
        @bits = bits.map{|bit|bit_for bit}.freeze
      end
      
      def bits
        @bits.dup
      end
      
      def to_i
        ret = 0
        
        RADIXIES.each_with_index do |radix, index|
          ret += radix * @bits[index]
        end
        
        ret
      end
      
      # 1..8
      # The reversing access from Ruby's Array
      def [](pos)
        index = pos.to_int
        raise IndexError unless (1..8).cover? index
        
        @bits[8 - index]
      end
      
      private
      
      def bit_for(bit)
        raise ArgumentError unless DEF_BIT.has_key? bit

        DEF_BIT[bit]
      end
    
    end

    PATTERN = /\A(?:[a-fA-F0-9][:\-]){5}(?:[a-fA-F0-9]\z/

    class << self
      
      def parse(str)
        case str
        when PATTERN
          new str.split(/[:\-]/)
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
      format @octets, delimiter
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
      format(@octets.take(5), '-') == '00-00-5e-00-01'
    end
    
    private

    # @param offset [Fixnum] 1..6
    def [](offset)
      @octets[offset - 1]
    end

    def format(octets, delimiter)
      octets.map(&:to_s).join delimiter
    end

  end

end
