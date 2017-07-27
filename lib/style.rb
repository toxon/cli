# frozen_string_literal: true

class Style
  class << self
    attr_accessor :default

    def counter
      @counter ||= 0
      @counter += 1
    end
  end

  def initialize
    Curses.init_pair logo_id,             logo_color,             logo_bg
    Curses.init_pair text_id,             text_color,             text_bg
    Curses.init_pair selection_id,        selection_color,        selection_bg
    Curses.init_pair editing_text_id,     editing_text_color,     editing_text_bg
    Curses.init_pair cursor_id,           cursor_color,           cursor_bg
    Curses.init_pair menu_item_id,        menu_item_color,        menu_item_bg
    Curses.init_pair active_menu_item_id, active_menu_item_color, active_menu_item_bg
    Curses.init_pair peer_info_name_id,   peer_info_name_color,   peer_info_name_bg

    Curses.init_pair online_mark_id,      online_mark_color,      online_mark_bg
    Curses.init_pair away_mark_id,        away_mark_color,        away_mark_bg
    Curses.init_pair busy_mark_id,        busy_mark_color,        busy_mark_bg

    Curses.init_pair message_time_id,     message_time_color,     message_time_bg
    Curses.init_pair message_author_id,   message_author_color,   message_author_bg
    Curses.init_pair message_error_id,    message_error_color,    message_error_bg
  end

  def logo(window)
    window.attron logo_attr
    yield
  ensure
    window.attroff logo_attr
  end

  def text(window)
    window.attron text_attr
    yield
  ensure
    window.attroff text_attr
  end

  def selection(window)
    window.attron selection_attr
    yield
  ensure
    window.attroff selection_attr
  end

  def editing_text(window)
    window.attron editing_text_attr
    yield
  ensure
    window.attroff editing_text_attr
  end

  def cursor(window)
    window.attron cursor_attr
    yield
  ensure
    window.attroff cursor_attr
  end

  def menu_item(window)
    window.attron menu_item_attr
    yield
  ensure
    window.attroff menu_item_attr
  end

  def active_menu_item(window)
    window.attron active_menu_item_attr
    yield
  ensure
    window.attroff active_menu_item_attr
  end

  def peer_info_name(window)
    window.attron peer_info_name_attr
    yield
  ensure
    window.attroff peer_info_name_attr
  end

  def online_mark(window)
    window.attron online_mark_attr
    yield
  ensure
    window.attroff online_mark_attr
  end

  def away_mark(window)
    window.attron away_mark_attr
    yield
  ensure
    window.attroff away_mark_attr
  end

  def busy_mark(window)
    window.attron busy_mark_attr
    yield
  ensure
    window.attroff busy_mark_attr
  end

  def message_time(window)
    window.attron message_time_attr
    yield
  ensure
    window.attroff message_time_attr
  end

  def message_author(window)
    window.attron message_author_attr
    yield
  ensure
    window.attroff message_author_attr
  end

  def message_error(window)
    window.attron message_error_attr
    yield
  ensure
    window.attroff message_error_attr
  end

private

  def logo_attr
    Curses.color_pair(logo_id) | Curses::A_BOLD
  end

  def text_attr
    Curses.color_pair text_id
  end

  def selection_attr
    Curses.color_pair selection_id
  end

  def editing_text_attr
    Curses.color_pair editing_text_id
  end

  def cursor_attr
    Curses.color_pair cursor_id
  end

  def menu_item_attr
    Curses.color_pair menu_item_id
  end

  def active_menu_item_attr
    Curses.color_pair active_menu_item_id
  end

  def peer_info_name_attr
    Curses.color_pair(peer_info_name_id) | Curses::A_BOLD
  end

  def online_mark_attr
    Curses.color_pair online_mark_id
  end

  def away_mark_attr
    Curses.color_pair away_mark_id
  end

  def busy_mark_attr
    Curses.color_pair busy_mark_id
  end

  def message_time_attr
    Curses.color_pair message_time_id
  end

  def message_author_attr
    Curses.color_pair(message_author_id) | Curses::A_BOLD
  end

  def message_error_attr
    Curses.color_pair message_error_id
  end

  def logo_id
    @logo_id ||= self.class.counter
  end

  def text_id
    @text_id ||= self.class.counter
  end

  def selection_id
    @selection_id ||= self.class.counter
  end

  def editing_text_id
    @editing_text_id ||= self.class.counter
  end

  def cursor_id
    @cursor_id ||= self.class.counter
  end

  def menu_item_id
    @menu_item_id ||= self.class.counter
  end

  def active_menu_item_id
    @active_menu_item_id ||= self.class.counter
  end

  def peer_info_name_id
    @peer_info_name_id ||= self.class.counter
  end

  def online_mark_id
    @online_mark_id ||= self.class.counter
  end

  def away_mark_id
    @away_mark_id ||= self.class.counter
  end

  def busy_mark_id
    @busy_mark_id ||= self.class.counter
  end

  def message_time_id
    @message_time_id ||= self.class.counter
  end

  def message_author_id
    @message_author_id ||= self.class.counter
  end

  def message_error_id
    @message_error_id ||= self.class.counter
  end

  def logo_color
    Curses::COLOR_BLUE
  end

  def logo_bg
    Curses::COLOR_BLACK
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

  def active_menu_item_color
    Curses::COLOR_BLACK
  end

  def active_menu_item_bg
    Curses::COLOR_BLUE
  end

  def peer_info_name_color
    Curses::COLOR_WHITE
  end

  def peer_info_name_bg
    Curses::COLOR_BLACK
  end

  def online_mark_color
    Curses::COLOR_GREEN
  end

  def online_mark_bg
    Curses::COLOR_BLACK
  end

  def away_mark_color
    Curses::COLOR_YELLOW
  end

  def away_mark_bg
    Curses::COLOR_BLACK
  end

  def busy_mark_color
    Curses::COLOR_RED
  end

  def busy_mark_bg
    Curses::COLOR_BLACK
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

  def message_error_color
    Curses::COLOR_RED
  end

  def message_error_bg
    Curses::COLOR_BLACK
  end
end
