# frozen_string_literal: true

module React
  class Curses
    module Nodes
      class Stdscr < Window
        def window
          @window ||= ::Curses.stdscr
        end

        def x
          0
        end

        def y
          0
        end

        def width
          window.maxx
        end

        def height
          window.maxy
        end

      private

        def parent=(value)
          raise TypeError, 'expected parent to be nil' unless value.nil?
          @parent = nil
        end
      end
    end
  end
end
