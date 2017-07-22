# frozen_string_literal: true

module Widgets
  class Menu < Base
    def initialize(x, y, _width, height)
      super x, y, Logo::WIDTH, height

      @logo  = Logo.new  x, y,            nil,         nil
      @items = Items.new x, @logo.height, @logo.width, nil
    end

    def draw
      @logo.render
      @items.render
    end
  end
end
