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
          props[:x]
        end

        def y
          props[:y]
        end

        def width
          props[:width]
        end

        def height
          props[:height]
        end

        def draw
          super
          window.refresh
        end

        def children
          return [] if props[:children].empty?
          raise 'window can include only single child' unless props[:children].size == 1
          super
        end
      end
    end
  end
end
