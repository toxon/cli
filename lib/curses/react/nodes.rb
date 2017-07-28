# frozen_string_literal: true

require 'curses/react/nodes/text'
require 'curses/react/nodes/wrapper'
require 'curses/react/nodes/line'

module Curses
  module React
    module Nodes
      def self.klass_for(element)
        raise TypeError, "expected element to be an #{Element}" unless element.is_a? Element

        case element.type
        when :text    then Text
        when :wrapper then Wrapper
        when :line    then Line
        else
          raise "unknown element type: #{element.type.inspect}"
        end
      end
    end
  end
end
