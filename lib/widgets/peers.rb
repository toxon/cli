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
      when Events::Panel::Up, Events::Panel::Down
        @list.trigger event
      when Events::Text::Putc,
           Events::Text::Left,
           Events::Text::Right,
           Events::Text::Home,
           Events::Text::End,
           Events::Text::Backspace,
           Events::Text::Delete
        @search.trigger event
      end
    end
  end
end
