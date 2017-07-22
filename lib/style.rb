# frozen_string_literal: true

class Style
  def self.counter
    @counter ||= 0
    @counter += 1
  end

  def initialize
    Curses.init_pair self.class.counter, Curses::COLOR_WHITE, Curses::COLOR_BLACK # text
    Curses.init_pair self.class.counter, Curses::COLOR_BLACK, Curses::COLOR_WHITE # selection
    Curses.init_pair self.class.counter, Curses::COLOR_WHITE, Curses::COLOR_BLACK # editing text
    Curses.init_pair self.class.counter, Curses::COLOR_BLACK, Curses::COLOR_GREEN # cursor
    Curses.init_pair self.class.counter, Curses::COLOR_BLACK, Curses::COLOR_CYAN  # menu item
    Curses.init_pair self.class.counter, Curses::COLOR_CYAN,  Curses::COLOR_BLACK # message time
    Curses.init_pair self.class.counter, Curses::COLOR_GREEN, Curses::COLOR_BLACK # message author
  end
end
