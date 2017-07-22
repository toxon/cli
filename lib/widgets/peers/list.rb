# frozen_string_literal: true

module Widgets
  class Peers < VPanel
    class List < Base
      attr_reader :active, :top, :items

      def initialize(x, y, width, height)
        super

        @active = 0
        @top    = 0

        @items = 1.upto(height - 1 + 10).map do
          {
            name: Faker::Name.name,
          }
        end
      end

      def render
        items[top...(top + height)].each_with_index.each do |item, offset|
          index = top + offset
          name = item[:name]

          Style.default.public_send(index == active && focused ? :selection : :text) do
            Curses.setpos y + offset, x

            s = "#{index}: #{name}"
            if s.length <= width
              Curses.addstr s.ljust width
            else
              Curses.addstr "#{s[0...width - 3]}..."
            end
          end
        end
      end

      def trigger(event)
        case event
        when Events::Panel::Up
          up
        when Events::Panel::Down
          down
        end
      end

      def up
        @active -= 1
        update
      end

      def down
        @active += 1
        update
      end

      def update
        if active.negative?
          @active = items.count - 1
        elsif active >= items.count
          @active = 0
        end

        if active < top
          @top = active
        elsif active >= top + height
          @top = active - height + 1
        end
      end
    end
  end
end
