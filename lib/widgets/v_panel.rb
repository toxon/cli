# frozen_string_literal: true

module Widgets
  class VPanel < Base
    def draw
      children.each(&:render)
    end

    def children
      raise NotImplementedError, "#{self.class}#children"
    end
  end
end
