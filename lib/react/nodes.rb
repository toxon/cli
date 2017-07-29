# frozen_string_literal: true

require 'curses'

require 'react/nodes/base'
require 'react/nodes/text'
require 'react/nodes/wrapper'
require 'react/nodes/line'
require 'react/nodes/lines'

require 'react/nodes/window'

module React
  module Nodes
    def self.klass_for(element)
      raise TypeError, "expected element to be an #{Element}" unless element.is_a? Element

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
