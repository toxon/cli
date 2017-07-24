# frozen_string_literal: true

module Widgets
  class Base
    attr_reader :window
    attr_reader :width, :height
    attr_accessor :focused

    def initialize(x, y, width, height)
      @window = Curses::Window.new height, width, y, x

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
