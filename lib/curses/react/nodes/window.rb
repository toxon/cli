# frozen_string_literal: true

module Curses
  module React
    module Nodes
      class Window < Wrapper
        def initialize(parent, element)
          self.element = element
          self.window = parent&.subwin(x, y, width, height) || Curses.stdscr
        end

        def subwin(x, y, width, height)
          window.subwin height, width, y, x
        end

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
          props[:height] || @height
        end

        def draw
          super
          window.refresh
        end

        def children
          return [] if props[:children].empty?
          raise 'window can include only single child' unless props[:children].size == 1
          super.each do |child_node|
            child_node.x = 0
            child_node.y = 0
            child_node.width = width
            child_node.height = height
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

        def height=(value)
          raise TypeError, "expected height to be an #{Integer}" unless value.is_a? Integer
          @height = value
        end
      end
    end
  end
end
