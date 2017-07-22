# frozen_string_literal: true

module Widgets
  class VPanel
    attr_reader :x, :y, :width, :height, :focused

    def initialize(x, y, width, height)
      @x = x
      @y = y

      @width  = width
      @height = height

      @focused = false
    end

    def render
      children.each(&:render)
    end

    def children
      raise NotImplementedError, "#{self.class}#children"
    end
  end
end
