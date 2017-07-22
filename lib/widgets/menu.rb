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
          setpos 2, 0 + list_y + index * 4
          Curses.addstr ' ' * (width - 4)

          setpos 2, 1 + list_y + index * 4
          Curses.addstr " #{item}".ljust width - 4

          setpos 2, 2 + list_y + index * 4
          Curses.addstr ' ' * (width - 4)
        end
      end
    end
  end
end
