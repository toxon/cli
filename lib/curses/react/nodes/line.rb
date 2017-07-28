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

      private

        def width=(value)
          raise TypeError, "expected width to be an #{Integer}" unless value.is_a? Integer
          @width = value
        end
      end
    end
  end
end
