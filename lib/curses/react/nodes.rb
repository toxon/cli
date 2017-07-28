# frozen_string_literal: true

require 'curses/react/nodes/text_line'
require 'curses/react/nodes/line'

module Curses
  module React
    module Nodes
      def self.create(element, window)
        raise TypeError, "expected element to be an #{Element}" unless element.is_a? Element

        case element.type
        when :text_line then TextLine.new element, window
        when :line      then Line.new     element, window
        else
          raise "unknown element type: #{element.type.inspect}"
        end
      end
    end
  end
end
