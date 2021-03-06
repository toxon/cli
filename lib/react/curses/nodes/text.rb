# frozen_string_literal: true

module React
  using Helpers

  class Curses
    module Nodes
      class Text < Base
        def draw
          return if text.nil?

          window.setpos  y, x
          window.attron  attr if attr
          window.addstr  text.ljustetc width
          window.attroff attr if attr
        end

        def width
          [text.length, max_width].min
        end

        def height
          1
        end

        def max_height
          1
        end

        def text
          props[:text] || ''
        end

        def attr
          props[:attr]
        end
      end
    end
  end
end
