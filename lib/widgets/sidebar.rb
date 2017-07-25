# frozen_string_literal: true

module Widgets
  class Sidebar < Container
    def initialize(_parent)
      super

      @logo = Logo.new self
      @menu = Menu.new self
    end

    def props=(_value)
      super

      @logo.props = props[:logo]

      @menu.props = props[:menu].merge(
        on_up:   props[:on_menu_up],
        on_down: props[:on_menu_down],
      ).freeze
    end

    def trigger(event)
      focus&.trigger event
    end

  private

    def focus
      case props[:focus]
      when :menu
        @menu
      end
    end

    def children
      [@logo, @menu]
    end
  end
end
