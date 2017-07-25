# frozen_string_literal: true

module Widgets
  class Base
    attr_reader :parent
    attr_reader :props

    def initialize(parent)
      @parent = parent
      @props = {}.freeze
    end

    def window
      @window ||= parent ? parent.window.subwin(props[:height], props[:width], props[:y], props[:x]) : Curses.stdscr
    end

    def trigger(event); end

    def props=(value)
      raise TypeError,     "expected props to be a #{Hash}" unless value.is_a? Hash
      raise ArgumentError, 'expected props to be frozen'    unless value.frozen?

      @window = nil if props[:x] != value[:x] || props[:y] != value[:y] ||
                       props[:width] != value[:width] || props[:height] != value[:height]

      @props = value
    end

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
