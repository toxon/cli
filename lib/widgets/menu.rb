# frozen_string_literal: true

module Widgets
  class Menu < Base
    ITEMS = [
      'Foo menu item',
      'Bar Car menu item',
      'Hello, World!',
    ].freeze

    def initialize(x, y, _width, height)
      super x, y, Logo::WIDTH, height

      @logo = Logo.new x, y, nil, nil
    end

    def draw
      @logo.draw

      list_y = y + @logo.height

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
