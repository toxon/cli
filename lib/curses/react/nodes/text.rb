# frozen_string_literal: true

module Curses
  using Helpers

  module React
    module Nodes
      class Text < Base
        attr_reader :x, :y, :max_width

        def initialize(element, window, x:, y:, max_width:)
          super element, window

          self.x = x
          self.y = y
          self.max_width = max_width
        end

        def max_height
          1
        end

        def width
          [props[:text].length, max_width].min
        end

        def height
          1
        end

        def text
          props[:text]
        end

        def attr
          props[:attr]
        end

        def draw
          return if text.nil?

          window.setpos  y, x
          window.attron  attr if attr
          window.addstr  text.ljustetc width
          window.attroff attr if attr
        end

      private

        def x=(value)
          raise TypeError,     "expected x to be an #{Integer}"                 unless value.is_a? Integer
          raise ArgumentError, 'expected x to be greater than or equal to zero' unless value >= 0
          @x = value
        end

        def y=(value)
          raise TypeError,     "expected y to be an #{Integer}"                 unless value.is_a? Integer
          raise ArgumentError, 'expected y to be greater than or equal to zero' unless value >= 0
          @y = value
        end

        def max_width=(value)
          raise TypeError, "expected max width to be an #{Integer}" unless value.is_a? Integer
          @max_width = value
        end
      end
    end
  end
end
