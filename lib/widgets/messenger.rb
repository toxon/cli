# frozen_string_literal: true

module Widgets
  class Messenger
    attr_reader :x, :y, :width, :height

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
    end

    def render
      @peers.render
      @chat.render
    end

    def putc(event)
      @peers.putc event
    end

    def left
      @peers.left
    end

    def right
      @peers.right
    end

    def home
      @peers.home
    end

    def endk
      @peers.endk
    end

    def backspace
      @peers.backspace
    end

    def delete
      @peers.delete
    end

    def up
      @peers.up
    end

    def down
      @peers.down
    end
  end
end
