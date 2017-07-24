# frozen_string_literal: true

module Widgets
  class Menu < Container
    def initialize(parent, x, y, _width, height)
      super parent, x, y, Logo::WIDTH, height

      @logo  = Logo.new  self, x, y,            nil,         nil
      @peers = Peers.new self, x, @logo.height, @logo.width, height - @logo.height

      self.focus = @peers
    end

    def children
      [@logo, @peers]
    end
  end
end
