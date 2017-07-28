# frozen_string_literal: true

require 'curses/react/nodes/text_line'
require 'curses/react/nodes/wrapper'

module Curses
  module React
    module Nodes
      def self.klass_for(element)
        raise TypeError, "expected element to be an #{Element}" unless element.is_a? Element

        case element.type
        when :text_line then TextLine
        when :wrapper   then Wrapper
        else
          raise "unknown element type: #{element.type.inspect}"
        end
      end
    end
  end
end
