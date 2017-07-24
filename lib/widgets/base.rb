# frozen_string_literal: true

module Widgets
  class Base
    attr_reader :x, :y, :width, :height
    attr_accessor :focused

    def initialize(x, y, width, height)
      @x = x
      @y = y

      @width  = width
      @height = height

      @focused = false
    end

    def window
      Curses
    end

    def trigger(event); end

    def render
      draw
    end

    def draw
      raise NotImplementedError, "#{self.class}#draw"
    end

    def setpos(x, y)
      window.setpos self.y + y, self.x + x
    end

    def addstr(s)
      window.addstr s
    end
  end
end
