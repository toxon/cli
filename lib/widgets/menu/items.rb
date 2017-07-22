# frozen_string_literal: true

module Widgets
  class Menu < Container
    class Items < Base
      ITEMS = [
        'Foo menu item',
        'Bar Car menu item',
        'Hello, World!',
      ].freeze

      def draw
        ITEMS.each_with_index do |item, index|
          Style.default.menu_item do
            setpos 2, 4 * index + 0
            Curses.addstr ' ' * (width - 4)

            setpos 2, 4 * index + 1
            Curses.addstr " #{item}".ljust width - 4

            setpos 2, 4 * index + 2
            Curses.addstr ' ' * (width - 4)
          end
        end
      end
    end
  end
end
