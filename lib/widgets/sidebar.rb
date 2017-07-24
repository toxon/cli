# frozen_string_literal: true

module Widgets
  class Sidebar < Container
    def initialize(parent, x, y, _width, height)
      super parent, x, y, Logo::WIDTH, height

      @logo = Logo.new self, x, y,            nil,         nil
      @menu = Menu.new self, x, @logo.height, @logo.width, height - @logo.height
    end

    def focus
      case props[:focus]
      when :menu
        @menu
      end
    end

    def props=(_value)
      super
      @menu.props = props[:menu]
    end

    def children
      [@logo, @menu]
    end
  end
end
