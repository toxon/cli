# frozen_string_literal: true

module Widgets
  class Menu < Container
    def initialize(x, y, _width, height)
      super x, y, Logo::WIDTH, height

      @logo  = Logo.new  x, y,            nil,         nil
      @items = Items.new x, @logo.height, @logo.width, height

      self.focus = @items
    end

    def children
      [@logo, @items]
    end
  end
end
