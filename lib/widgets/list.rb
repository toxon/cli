# frozen_string_literal: true

module Widgets
  class List
    attr_reader :x, :y, :width, :height
    attr_accessor :focused

    attr_reader :active, :top, :items

    def initialize(x, y, width, height)
      @x = x
      @y = y

      @width  = width
      @height = height

      @focused = false

      @active = 0
      @top    = 0

      @items = 1.upto(height - 1 + 10).map do
        Faker::Name.name
      end
    end

    def render
      items[top...(top + height)].each_with_index.each do |item, offset|
        index = top + offset

        if index == active && focused
          Curses.attron Curses.color_pair 2
        else
          Curses.attron Curses.color_pair 1
        end

        Curses.setpos y + offset, x

        s = "#{index}: #{item}"
        if s.length <= width
          Curses.addstr s.ljust width
        else
          Curses.addstr "#{s[0...width - 3]}..."
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
