# frozen_string_literal: true

require 'curses'

require 'react/curses/nodes/base'
require 'react/curses/nodes/component'
require 'react/curses/nodes/text'
require 'react/curses/nodes/wrapper'
require 'react/curses/nodes/line'
require 'react/curses/nodes/lines'
require 'react/curses/nodes/window'

module React
  class Curses
    module Nodes
      def self.klass_for(element)
        raise TypeError, "expected element to be an #{Element}" unless element.is_a? Element

        return Component if element.type.is_a?(Class) && element.type < React::Component

        case element.type
        when :text    then Text
        when :wrapper then Wrapper
        when :line    then Line
        when :lines   then Lines
        when :window  then Window
        else
          raise "unknown element type: #{element.type.inspect}"
        end
      end
    end
  end
end
