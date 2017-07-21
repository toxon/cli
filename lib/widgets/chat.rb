# frozen_string_literal: true

module Widgets
  class Chat
    attr_reader :x, :y, :width, :height

    def initialize(x, y, width, height)
      @x = x
      @y = y

      @width  = width
      @height = height
    end

    def render
    end
  end
end
