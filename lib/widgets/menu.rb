# frozen_string_literal: true

module Widgets
  class Menu
    ITEMS = [
      'Foo menu item',
      'Bar Car menu item',
      'Hello, World!',
    ].freeze

    attr_reader :x, :y, :width, :height

    def initialize(x, y, width, height)
      @x = x
      @y = y

      @width  = width
      @height = height
    end

    def render
      ITEMS.each_with_index do |item, index|
        Curses.attron Curses.color_pair 5

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
