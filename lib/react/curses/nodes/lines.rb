# frozen_string_literal: true

module React
  class Curses
    module Nodes
      class Lines < Wrapper
        def children
          props[:children].each_with_index.map do |child_element, index|
            node_klass = Nodes.klass_for child_element
            raise "#{self.class} can only have children of type #{Line}" unless node_klass <= Line
            node_klass.new self, child_element, x: x, y: y + index, width: width, rjust: rjust
          end
        end

        def height
          props[:children].size
        end

        def rjust
          return props[:rjust] unless props[:jrust].nil?
          false
        end
      end
    end
  end
end
