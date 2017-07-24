# frozen_string_literal: true

module Widgets
  class Base
    attr_reader :parent
    attr_reader :window
    attr_reader :width, :height
    attr_accessor :focused

    def initialize(parent, x, y, width, height)
      @parent = parent

      @window = parent ? parent.window.subwin(height, width, y, x) : Curses.stdscr

      @width  = width
      @height = height

      @focused = false
    end

    def trigger(event); end

    def render
      draw
      window.refresh
    end

    def draw
      raise NotImplementedError, "#{self.class}#draw"
    end

    def setpos(x, y)
      window.setpos y, x
    end

    def addstr(s)
      window.addstr s
    end
  end
end
