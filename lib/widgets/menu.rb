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

      ITEMS.each_with_index do |item, index|
        item_y = @logo.height + index * 4

        Style.default.menu_item do
          setpos 2, item_y + 0
          Curses.addstr ' ' * (width - 4)

          setpos 2, item_y + 1
          Curses.addstr " #{item}".ljust width - 4

          setpos 2, item_y + 2
          Curses.addstr ' ' * (width - 4)
        end
      end
    end
  end
end
