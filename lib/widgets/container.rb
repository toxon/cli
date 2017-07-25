# frozen_string_literal: true

module Widgets
  class Container < Base
    def draw
      children.each(&:render)
    end

    def focus
      raise NotImplementedError, "#{self.class}#focus"
    end

    def children
      raise NotImplementedError, "#{self.class}#children"
    end
  end
end
