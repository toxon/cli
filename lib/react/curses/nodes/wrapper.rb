# frozen_string_literal: true

module React
  module Curses
    module Nodes
      class Wrapper < Base
        def draw
          children.each(&:draw)
        end

        def children
          props[:children].map do |child_element|
            Nodes.klass_for(child_element).new child_element, window
          end
        end
      end
    end
  end
end
