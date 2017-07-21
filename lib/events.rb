# frozen_string_literal: true

module Events
  module Panel
    class Up; end
    class Down; end
  end

  module Text
    class Putc
      attr_reader :char

      def initialize(char)
        raise TypeError unless char.is_a?(String) && char.size == 1
        @char = char.freeze
      end
    end

    class Left; end
    class Right; end
    class Home; end
    class End; end
    class Backspace; end
    class Delete; end
  end
end
