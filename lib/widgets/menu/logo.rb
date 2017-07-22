# frozen_string_literal: true

module Widgets
  class Menu < Base
    class Logo < Base
      LOGO = [
        '  _____ ___ _  _ ___  _   _  ',
        ' |_   _/ _ \ \/ / _ \| \ | | ',
        '   | || | | \  / | | |  \| | ',
        '   | || |_| /  \ |_| | |\  | ',
        '   |_| \___/_/\_\___/|_| \_| ',
        '                             ',
      ].freeze

      WIDTH  = LOGO.first.length
      HEIGHT = LOGO.length

      def initialize(x, y, _width, _height)
        super x, y, WIDTH, HEIGHT
      end

      def draw
        Style.default.logo do
          LOGO.each_with_index do |s, index|
            Curses.setpos y + index, x
            Curses.addstr s
          end
        end
      end
    end
  end
end
