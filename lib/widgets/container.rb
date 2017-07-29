# frozen_string_literal: true

module Widgets
  class Container < React::Component
    def subwin(x, y, width, height)
      window.subwin height, width, y, x
    end

  private

    def render
      children.each(&:draw)
    end

    def focus
      raise NotImplementedError, "#{self.class}#focus"
    end

    def children
      raise NotImplementedError, "#{self.class}#children"
    end
  end
end
