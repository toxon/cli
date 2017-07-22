# frozen_string_literal: true

class Style
  def self.counter
    @counter ||= 0
    @counter += 1
  end

  def initialize
    Curses.init_pair self.class.counter, text_color,           text_bg
    Curses.init_pair self.class.counter, selection_color,      selection_bg
    Curses.init_pair self.class.counter, editing_text_color,   editing_text_bg
    Curses.init_pair self.class.counter, cursor_color,         cursor_bg
    Curses.init_pair self.class.counter, menu_item_color,      menu_item_bg
    Curses.init_pair self.class.counter, message_time_color,   message_time_bg
    Curses.init_pair self.class.counter, message_author_color, message_author_bg
  end

  def text_color
    Curses::COLOR_WHITE
  end

  def text_bg
    Curses::COLOR_BLACK
  end

  def selection_color
    Curses::COLOR_BLACK
  end

  def selection_bg
    Curses::COLOR_WHITE
  end

  def editing_text_color
    Curses::COLOR_WHITE
  end

  def editing_text_bg
    Curses::COLOR_BLACK
  end

  def cursor_color
    Curses::COLOR_BLACK
  end

  def cursor_bg
    Curses::COLOR_GREEN
  end

  def menu_item_color
    Curses::COLOR_BLACK
  end

  def menu_item_bg
    Curses::COLOR_CYAN
  end

  def message_time_color
    Curses::COLOR_CYAN
  end

  def message_time_bg
    Curses::COLOR_BLACK
  end

  def message_author_color
    Curses::COLOR_GREEN
  end

  def message_author_bg
    Curses::COLOR_BLACK
  end
end
