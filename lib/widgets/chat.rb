# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    def initialize(parent, x, y, width, height)
      super

      info_height    = 2
      message_height = 1
      history_height = height - info_height - message_height

      info_top    = 0
      history_top = info_height
      message_top = info_height + history_height

      @info    = Info.new       self, x, y + info_top,    width, info_height
      @history = History.new    self, x, y + history_top, width, history_height
      @message = NewMessage.new self, x, y + message_top, width, message_height
    end

    def children
      [@info, @history, @message]
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
      @info.focused    = focused
      @history.focused = focused
      @message.focused = focused
    end
  end
end
