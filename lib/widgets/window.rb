# frozen_string_literal: true

module Widgets
  class Window < Container
    def initialize(x, y, width, height)
      super

      @menu      = Widgets::Menu.new      0,           0, nil,                              Curses.stdscr.maxy
      @messenger = Widgets::Messenger.new @menu.width, 0, Curses.stdscr.maxx - @menu.width, Curses.stdscr.maxy

      self.focus = @menu
    end

    def children
      [@menu, @messenger]
    end
  end
end
