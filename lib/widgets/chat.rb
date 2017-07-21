# frozen_string_literal: true

module Widgets
  class Chat
    attr_reader :x, :y, :width, :height
    attr_reader :focused

    def initialize(x, y, width, height)
      @x = x
      @y = y

      @width  = width
      @height = height

      @message = NewMessage.new x, y + height - 1, width, 1
      @history = History.new    x, y,              width, height - 1

      @focused = false
    end

    def render
      @history.render
      @message.render
    end

    def trigger(event)
      case event
      when Events::Panel::Base
        @history.trigger event
      when Events::Text::Base
        @message.trigger event
      end
    end

    def focused=(value)
      @focused = !!value
      @history.focused = focused
      @message.focused = focused
    end
  end
end
