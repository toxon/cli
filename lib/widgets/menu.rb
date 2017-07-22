# frozen_string_literal: true

module Widgets
  class Menu < Base
    LOGO = <<~END.lines.map { |s| s.gsub(/\n$/, '') }
      ____________  _____  _   _
      |_   _/ _ \\ \\/ / _ \\| \\ | |
        | || | | \\  / | | | \\ | |
        | || |_| /  \\ |_| | |\\  |
        |_| \\___/_/\\_\\___/|_| \\_|
    END

    LOGO_WIDTH = LOGO.map(&:length).max
    SIDE_PADDING = 1

    ITEMS = [
      'Foo menu item',
      'Bar Car menu item',
      'Hello, World!',
    ].freeze

    def initialize(x, y, _width, height)
      super x, y, LOGO_WIDTH + 2 * SIDE_PADDING, height
    end

    def render
      LOGO.each_with_index do |s, index|
        Curses.setpos y + index, SIDE_PADDING
        Curses.addstr s
      end

      list_y = y + LOGO.count + 1

      ITEMS.each_with_index do |item, index|
        Style.default.menu_item do
          Curses.setpos 0 + list_y + index * 4, 2
          Curses.addstr ' ' * (width - 4)

          Curses.setpos 1 + list_y + index * 4, 2
          Curses.addstr " #{item}".ljust width - 4

          Curses.setpos 2 + list_y + index * 4, 2
          Curses.addstr ' ' * (width - 4)
        end
      end
    end
  end
end
