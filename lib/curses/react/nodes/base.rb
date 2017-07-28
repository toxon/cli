# frozen_string_literal: true

module Curses
  module React
    module Nodes
      class Base
        attr_reader :element, :window

        def initialize(element, window)
          self.element = element
          self.window = window
        end

        def props
          element.all_props
        end

        def draw
          raise NotImplementedError, "#{self.class}#draw"
        end

      private

        def element=(value)
          raise TypeError, "expected element to be an #{Element}" unless value.is_a? Element
          @element = value
        end

        def window=(value)
          raise TypeError, "expected window to be an #{Curses::Window}" unless value.is_a? Curses::Window
          @window = value
        end
      end
    end
  end
end
