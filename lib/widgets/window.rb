# frozen_string_literal: true

module Widgets
  class Window < Container
    def initialize(x, y, width, height)
      super

      @menu = Widgets::Menu.new 0, 0, nil, Curses.stdscr.maxy

      @messenger = Widgets::Messenger.new(
        0,
        0,
        Curses.stdscr.maxx - @menu.width,
        Curses.stdscr.maxy,
      )

      self.focus = @messenger

      @menu_visible = false
    end

    def children
      focus == @menu ? [@messenger, @menu] : [@messenger]
    end

    def trigger(event)
      case event
      when Events::Tab
        self.focus = focus == @menu ? @messenger : @menu
      else
        focus.trigger event
      end
    end
  end
end
