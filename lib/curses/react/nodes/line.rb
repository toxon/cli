# frozen_string_literal: true

module Curses
  module React
    module Nodes
      class Line < Wrapper
        attr_reader :width

        def initialize(element, window, width:)
          super element, window
          self.width = width
        end

        def children
          left = 0
          props[:children].map do |child_element|
            node_klass = Nodes.klass_for child_element
            raise "#{self.class} can only have children of type #{Text}" unless node_klass <= Text
            child_node = node_klass.new child_element, @window, x: left, max_width: width - left
            left += child_node.width
            child_node
          end
        end

      private

        def width=(value)
          raise TypeError, "expected width to be an #{Integer}" unless value.is_a? Integer
          @width = value
        end
      end
    end
  end
end
