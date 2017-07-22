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
            online: [false, true].sample,
          }
        end
      end

      def render
        items[top...(top + height)].each_with_index.each do |item, offset|
          index = top + offset

          Curses.setpos y + offset, x

          if item[:online]
            Style.default.online_mark do
              Curses.addstr '*'
            end
          else
            Curses.addstr 'o'
          end

          Curses.addstr ' '

          Style.default.public_send(index == active && focused ? :selection : :text) do
            s = "#{index}: #{item[:name]}"
            if s.length <= width - 2
              Curses.addstr s.ljust width - 2
            else
              Curses.addstr "#{s[0...width - 5]}..."
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
