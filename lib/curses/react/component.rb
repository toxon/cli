# frozen_string_literal: true

module Curses
  module React
    class Component
      def initialize(parent)
        self.parent = parent
        @props = {}.freeze
      end

      def props=(value)
        raise TypeError,     "expected props to be a #{Hash}" unless value.is_a? Hash
        raise ArgumentError, 'expected props to be frozen'    unless value.frozen?

        @window = nil if props[:x] != value[:x] || props[:y] != value[:y] ||
                         props[:width] != value[:width] || props[:height] != value[:height]

        @props = value
      end

      def trigger(event); end

      def draw
        render
        window.refresh
      end

    private

      attr_reader :parent, :props

      def parent=(value)
        return if value.nil?
        raise TypeError, "expected #parent to be a #{Component}" unless value.is_a? Component
        @parent = value
      end

      def window
        @window ||= parent&.subwin(props[:x], props[:y], props[:width], props[:height]) || Curses.stdscr
      end

      def render
        raise NotImplementedError, "#{self.class}#render"
      end

      def setpos(x, y)
        window.setpos y, x
      end

      def addstr(s)
        window.addstr s
      end

      def create_element(type, props = {}, &block)
        Element.create type, props, &block
      end
    end
  end
end
