# frozen_string_literal: true

module Widgets
  class Messenger
    attr_reader :x, :y, :width, :height
    attr_reader :focused, :focus

    def initialize(x, y, width, height)
      @x = x
      @y = y

      @width  = width
      @height = height

      peers_width = width / 4
      chat_width  = width - peers_width

      peers_left = 0
      chat_left  = peers_width

      @peers = Widgets::Peers.new x + peers_left, y, peers_width, height
      @chat  = Widgets::Chat.new  x + chat_left,  y, chat_width,  height

      @focused = false
      @focus = @peers
    end

    def render
      @peers.render
      @chat.render
    end

    def trigger(event)
      case event
      when Events::Window::Left
        left
      when Events::Window::Right
        right
      else
        @focus.trigger event
      end
    end

    def left
      self.focus = @peers
    end

    def right
      self.focus = @chat
    end

    def focused=(value)
      @focused = !!value
      focus.focused = focused
    end

    def focus=(child)
      focus.focused = false
      @focus = child
      focus.focused = true if focused
    end
  end
end
