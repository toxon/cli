# frozen_string_literal: true

require 'react/curses/nodes'

module React
  class Curses
    def render(element)
      Nodes.klass_for(element).new(nil, element).draw
    end
  end
end
