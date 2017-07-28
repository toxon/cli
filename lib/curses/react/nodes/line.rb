# frozen_string_literal: true

module Curses
  module React
    module Nodes
      class Line < Wrapper
        attr_reader :x, :y, :width

        def initialize(element, window, x:, y:, width:)
          super element, window

          self.x = x
          self.y = y
          self.width = width
        end

        def height
          1
        end

        def attr
          props[:attr]
        end

        def draw
          window.attron attr if attr
          super
          window.attroff attr if attr
        end

        def children
          left = 0
          props[:children].map do |child_element|
            node_klass = Nodes.klass_for child_element
            raise "#{self.class} can only have children of type #{Text}" unless node_klass <= Text
            child_node = node_klass.new child_element, @window, x: x + left, y: y, max_width: width - left
            left += child_node.width
            child_node
          end
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

        def width=(value)
          raise TypeError, "expected width to be an #{Integer}" unless value.is_a? Integer
          @width = value
        end
      end
    end
  end
end
