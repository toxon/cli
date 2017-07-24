# frozen_string_literal: true

module Widgets
  class Main < Container
    def initialize(x, y, width, height)
      super

      menu_width = width / 4
      chat_width = width - menu_width

      menu_left = 0
      chat_left = menu_width

      @menu = Widgets::Menu.new x + menu_left, y, menu_width, height
      @chat = Widgets::Chat.new x + chat_left, y, chat_width, height

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
