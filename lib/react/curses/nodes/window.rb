# frozen_string_literal: true

module React
  class Curses
    module Nodes
      class Window < Wrapper
        def window
          @window ||= parent.window.subwin height, width, y, x
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
      end
    end
  end
end
