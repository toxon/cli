# frozen_string_literal: true

module React
  class Curses
    module Nodes
      class Component < Base
        def instance
          result = element.type.new nil
          result.props = props
          result
        end

        def draw
          elem = instance.render
          Nodes.klass_for(elem).new(self, elem).draw
        end
      end
    end
  end
end
