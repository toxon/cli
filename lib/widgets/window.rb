# frozen_string_literal: true

module Widgets
  class Window < Container
    attr_reader :focus

    def initialize(x, y, width, height)
      super

      @menu      = Widgets::Menu.new      0,           0, nil,                              Curses.stdscr.maxy
      @messenger = Widgets::Messenger.new @menu.width, 0, Curses.stdscr.maxx - @menu.width, Curses.stdscr.maxy

      self.focus = @messenger
    end

    def trigger(event)
      focus.trigger event
    end

    def draw
      @menu.render
      @messenger.render
    end

    def focus=(value)
      focus.focused = false if focus
      @focus = value
      focus.focused = true
    end
  end
end
