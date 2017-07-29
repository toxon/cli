# frozen_string_literal: true

module React
  module Nodes
    class Base
      attr_reader :element, :window

      def initialize(element, window, options = {})
        self.element = element
        self.window = window

        options.each do |k, v|
          public_send :"#{k}=", v
        end
      end

      def props
        element.all_props
      end

      def draw
        raise NotImplementedError, "#{self.class}#draw"
      end

      def window=(value)
        raise TypeError, "expected window to be an #{Curses::Window}" unless value.is_a? Curses::Window
        @window = value
      end

      def x
        props[:x] || @x
      end

      def x=(value)
        raise TypeError, "expected x to be an #{Integer}" unless value.is_a? Integer
        @x = value
      end

      def y
        props[:y] || @y
      end

      def y=(value)
        raise TypeError, "expected y to be an #{Integer}" unless value.is_a? Integer
        @y = value
      end

      def width
        props[:width] || @width
      end

      def width=(value)
        raise TypeError, "expected width to be an #{Integer}" unless value.is_a? Integer
        @width = value
      end

      def height
        props[:height] || @height
      end

      def height=(value)
        raise TypeError, "expected height to be an #{Integer}" unless value.is_a? Integer
        @height = value
      end

      def max_width
        [props[:max_width], @max_width].compact.min
      end

      def max_width=(value)
        raise TypeError, "expected max width to be an #{Integer}" unless value.is_a? Integer
        @max_width = value
      end

      def max_height
        [props[:max_height], @max_height].compact.min
      end

      def max_height=(value)
        raise TypeError, "expected max height to be an #{Integer}" unless value.is_a? Integer
        @max_height = value
      end

    private

      def element=(value)
        raise TypeError, "expected element to be an #{Element}" unless value.is_a? Element
        @element = value
      end
    end
  end
end
