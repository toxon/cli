# frozen_string_literal: true

module React
  module Curses
    module Nodes
      class Component < Base
        def initialize(parent, element)
          @parent = parent
          self.element = element
        end

        def instance
          result = element.type.new @parent
          result.props = props
          result
        end

        def draw
          elem = instance.send :render
          Nodes.klass_for(elem).new(@parent, elem).draw
        end
      end
    end
  end
end
