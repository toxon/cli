# frozen_string_literal: true

module Widgets
  class Peers
    def initialize(x, y, width, height)
      @search = Widgets::Search.new x, y,     width, 1
      @list   = Widgets::List.new   x, y + 1, width, height - 1
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
  end
end
