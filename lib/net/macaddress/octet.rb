# Copyright (c) 2012 Kenichi Kamiya

module Net

  # Immutable
  class MACAddress

    # Immutable
    class Octet

      RADIXIES = [128, 64, 32, 16, 8, 4, 2, 1].freeze
      DEF_BIT = {0 => 0, 1 => 1, true => 1, false => 0}.freeze
      PATTERN_STR = '[a-fA-F0-9]{2}'.freeze
      PATTERN = /\A#{PATTERN_STR}\z/

      class << self
        
        def parse(str)
          raise MalformedDataError unless PATTERN.match str

          new bits_for(str.to_i(16))
        end

        def bit_for(obj)
          raise ArgumentError unless DEF_BIT.has_key? obj

          DEF_BIT[obj]
        end

        private

        def bits_for(int)
          int = int.to_int
          raise ArgumentError unless (0..255).cover? int
          
          int.to_s(2).rjust(8, '0').split('').map{|c|Integer c}
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
        RADIXIES.each_with_index.inject(0) {|sum, radix_index|
          radix, index = *radix_index
          sum + radix * @bits[index]
        }
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

      def eql?(other)
        self.class == other.class && to_i == other.to_i
      end

      alias_method :==, :eql?

      def hash
        @bits.hash
      end
      
      private
      
      def bit_for(obj)
        self.class.__send__ __callee__, obj
      end
    
    end

  end

end
