# frozen_string_literal: true

module Curses
  module React
    module Nodes
      class Lines < Wrapper
        def children
          props[:children].each_with_index.map do |child_element, index|
            node_klass = Nodes.klass_for child_element
            raise "#{self.class} can only have children of type #{Line}" unless node_klass <= Line
            node_klass.new child_element, window, x: x, y: y + index, width: width
          end
        end

        def height
          props[:children].size
        end
      end
    end
  end
end
