# frozen_string_literal: true

module Widgets
  class Menu < Container
    def initialize(x, y, _width, height)
      super x, y, Logo::WIDTH, height

      @logo  = Logo.new  x, y,            nil,         nil
      @peers = Peers.new x, @logo.height, @logo.width, height - @logo.height

      self.focus = @peers
    end

    def children
      [@logo, @peers]
    end
  end
end
