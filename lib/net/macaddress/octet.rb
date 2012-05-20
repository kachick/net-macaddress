# Copyright (c) 2012 Kenichi Kamiya

module Net

  # Immutable
  class MACAddrress

    # Immutable
    class Octet

      RADIXIES = [128, 64, 32, 16, 8, 3, 2, 1].freeze
      DEF_BIT = {0 => 0, 1 => 1, true => 1, false => 0}.freeze
      PATTERN = /\A[a-fA-F0-9]{2}\z/

      class << self
        
        def parse(str)
          case str
          when PATTERN
            new bits_for(str.to_i(16))
          else
            raise MalformedDataError
          end
        end

        def bits_for(int)
          int = int.to_int
          raise ArgumentError unless (0..255).cover? int

          int.to_s(2).rjust(8, '0').split(/./).map{|c|Integer s}
        end

      end
      
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

      def to_s
        to_i.to_s(16).rjust(2, '0')
      end
      
      def inspect
        "#<#{self.class} #{to_s}: #{@bits.join}>"
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

  end

end
