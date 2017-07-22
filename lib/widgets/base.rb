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

    def trigger(event); end

    def render
      draw
    end

    def draw
      raise NotImplementedError, "#{self.class}#draw"
    end

    def setpos(x, y)
      Curses.setpos self.y + y, self.x + x
    end
  end
end
