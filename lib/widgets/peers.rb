# frozen_string_literal: true

module Widgets
  class Peers
    attr_reader :focused

    def initialize(x, y, width, height)
      @focused = false

      @search = Search.new x, y,     width, 1
      @list   = List.new   x, y + 1, width, height - 1
    end

    def render
      @search.render
      @list.render
    end

    def trigger(event)
      case event
      when Events::Panel::Base
        @list.trigger event
      when Events::Text::Base
        @search.trigger event
      end
    end

    def focused=(value)
      @focused = !!value
      @list.focused = focused
      @search.focused = focused
    end
  end
end
