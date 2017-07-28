# frozen_string_literal: true

module Curses
  using Helpers

  module React
    module Nodes
      class Text
        def initialize(element, window)
          @element = element
          @window = window
        end

        def props
          @element.all_props
        end

        def draw
          return if props[:text].nil?
          @window.attron props[:attr] if props[:attr]
          setpos props[:x], props[:y]
          addstr props[:text].ljustetc props[:width]
          @window.attroff props[:attr] if props[:attr]
        end

        def setpos(x, y)
          @window.setpos y, x
        end

        def addstr(s)
          @window.addstr s
        end
      end
    end
  end
end
