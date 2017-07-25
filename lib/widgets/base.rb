# frozen_string_literal: true

module Widgets
  class Base
    def initialize(parent)
      @parent = parent
      @props = {}.freeze
    end

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

  private

    attr_reader :parent, :props

    def window
      @window ||= parent&.subwin(props[:x], props[:y], props[:width], props[:height]) || Curses.stdscr
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
