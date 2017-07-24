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

      attr_reader :active

      def initialize(*)
        super

        @active = 0
      end

      def trigger(event)
        case event
        when Events::Panel::Up
          up
        when Events::Panel::Down
          down
        end
      end

      def draw
        ITEMS.each_with_index do |item, index|
          draw_item index, item
        end
      end

      def draw_item(index, name)
        Style.default.public_send(index == active ? :active_menu_item : :menu_item, window) do
          setpos SIDE_PADDING, 4 * index + 0
          addstr ' ' * (width - 2 * SIDE_PADDING)

          setpos SIDE_PADDING, 4 * index + 1
          addstr " #{name}".ljust width - 2 * SIDE_PADDING

          setpos SIDE_PADDING, 4 * index + 2
          addstr ' ' * (width - 2 * SIDE_PADDING)
        end
      end

      def up
        @active -= 1 if active.positive?
      end

      def down
        @active += 1 if active < ITEMS.count - 1
      end
    end
  end
end
