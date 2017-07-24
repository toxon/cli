# frozen_string_literal: true

module Widgets
  class Sidebar < Container
    def initialize(parent, x, y, _width, height)
      super parent, x, y, Logo::WIDTH, height

      @logo = Logo.new self, x, y,            nil,         nil
      @menu = Menu.new self, x, @logo.height, @logo.width, height - @logo.height

      self.focus = @menu
    end

    def children
      [@logo, @menu]
    end
  end
end
