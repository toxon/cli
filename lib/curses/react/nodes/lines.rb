# frozen_string_literal: true

module Curses
  module React
    module Nodes
      class Lines < Wrapper
        def x
          props[:x] || @x
        end

        def y
          props[:y] || @y
        end

        def width
          props[:width] || @width
        end

        def height
          props[:children].size
        end

        def children
          props[:children].each_with_index.map do |child_element, index|
            node_klass = Nodes.klass_for child_element
            raise "#{self.class} can only have children of type #{Line}" unless node_klass <= Line
            node_klass.new child_element, window, x: x, y: y + index, width: width
          end
        end

        def x=(value)
          raise TypeError, "expected x to be an #{Integer}" unless value.is_a? Integer
          @x = value
        end

        def y=(value)
          raise TypeError, "expected y to be an #{Integer}" unless value.is_a? Integer
          @y = value
        end

        def width=(value)
          raise TypeError, "expected width to be an #{Integer}" unless value.is_a? Integer
          @width = value
        end

        def height=(_value); end
      end
    end
  end
end
