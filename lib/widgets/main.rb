# frozen_string_literal: true

module Widgets
  class Main < Container
    def initialize(parent, x, y, width, height)
      super

      @menu = Widgets::Menu.new self, x,               y, nil,                 height
      @chat = Widgets::Chat.new self, x + @menu.width, y, width - @menu.width, height

      self.focus = @menu
    end

    def children
      [@menu, @chat]
    end

    def trigger(event)
      case event
      when Events::Window::Left
        self.focus = @menu
      when Events::Window::Right
        self.focus = @chat
      else
        focus.trigger event
      end
    end
  end
end
