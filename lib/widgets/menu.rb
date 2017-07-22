# frozen_string_literal: true

module Widgets
  class Menu < Base
    ITEMS = [
      'Foo menu item',
      'Bar Car menu item',
      'Hello, World!',
    ].freeze

    def render
      ITEMS.each_with_index do |item, index|
        Style.default.menu_item do
          Curses.setpos 1 + y + index * 4, 2
          Curses.addstr ' ' * (width - 4)

          Curses.setpos 2 + y + index * 4, 2
          Curses.addstr " #{item}".ljust width - 4

          Curses.setpos 3 + y + index * 4, 2
          Curses.addstr ' ' * (width - 4)
        end
      end
    end
  end
end
