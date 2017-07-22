# frozen_string_literal: true

module Widgets
  class Menu < Container
    class Items < Base
      ITEMS = [
        'Foo menu item',
        'Bar Car menu item',
        'Hello, World!',
      ].freeze

      SIDE_PADDING = 3

      def draw
        ITEMS.each_with_index do |item, index|
          draw_item index, item
        end
      end

      def draw_item(index, name)
        Style.default.menu_item do
          setpos SIDE_PADDING, 4 * index + 0
          Curses.addstr ' ' * (width - 2 * SIDE_PADDING)

          setpos SIDE_PADDING, 4 * index + 1
          Curses.addstr " #{name}".ljust width - 2 * SIDE_PADDING

          setpos SIDE_PADDING, 4 * index + 2
          Curses.addstr ' ' * (width - 2 * SIDE_PADDING)
        end
      end
    end
  end
end
