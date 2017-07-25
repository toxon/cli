# frozen_string_literal: true

module Events
  module Window
    class Left;  end
    class Right; end
  end

  module Text
    class Left;      end
    class Right;     end
    class Up;        end
    class Down;      end
    class Home;      end
    class End;       end
    class Backspace; end
    class Delete;    end

    class Putc
      attr_reader :char

      def initialize(char)
        raise TypeError,     "expected char to be a #{String}" unless char.is_a? String
        raise ArgumentError, 'expected char to have length 1'  unless char.length == 1

        @char = char.frozen? ? char : char.dup.freeze
      end
    end
  end
end
