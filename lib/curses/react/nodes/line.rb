# frozen_string_literal: true

module Curses
  module React
    module Nodes
      class Line < Wrapper
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

        def height
          1
        end

        def attr
          props[:attr]
        end
      end
    end
  end
end
