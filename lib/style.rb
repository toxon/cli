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
    Curses.init_pair text_id,           text_color,           text_bg
    Curses.init_pair selection_id,      selection_color,      selection_bg
    Curses.init_pair editing_text_id,   editing_text_color,   editing_text_bg
    Curses.init_pair cursor_id,         cursor_color,         cursor_bg
    Curses.init_pair menu_item_id,      menu_item_color,      menu_item_bg
    Curses.init_pair message_time_id,   message_time_color,   message_time_bg
    Curses.init_pair message_author_id, message_author_color, message_author_bg
    Curses.init_pair online_mark_id,    online_mark_color,    online_mark_bg
    Curses.init_pair peer_info_name_id, peer_info_name_color, peer_info_name_bg
  end

  def text
    Curses.attron text_attr
    yield
  ensure
    Curses.attroff text_attr
  end

  def selection
    Curses.attron selection_attr
    yield
  ensure
    Curses.attroff selection_attr
  end

  def editing_text
    Curses.attron editing_text_attr
    yield
  ensure
    Curses.attroff editing_text_attr
  end

  def cursor
    Curses.attron cursor_attr
    yield
  ensure
    Curses.attroff cursor_attr
  end

  def menu_item
    Curses.attron menu_item_attr
    yield
  ensure
    Curses.attroff menu_item_attr
  end

  def message_time
    Curses.attron message_time_attr
    yield
  ensure
    Curses.attroff message_time_attr
  end

  def message_author
    Curses.attron message_author_attr
    yield
  ensure
    Curses.attroff message_author_attr
  end

  def online_mark
    Curses.attron online_mark_attr
    yield
  ensure
    Curses.attroff online_mark_attr
  end

  def peer_info_name
    Curses.attron peer_info_name_attr
    yield
  ensure
    Curses.attroff peer_info_name_attr
  end

private

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

  def message_time_attr
    Curses.color_pair message_time_id
  end

  def message_author_attr
    Curses.color_pair(message_author_id) | Curses::A_BOLD
  end

  def online_mark_attr
    Curses.color_pair online_mark_id
  end

  def peer_info_name_attr
    Curses.color_pair(peer_info_name_id) | Curses::A_BOLD
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

  def message_time_id
    @message_time_id ||= self.class.counter
  end

  def message_author_id
    @message_author_id ||= self.class.counter
  end

  def online_mark_id
    @online_mark_id ||= self.class.counter
  end

  def peer_info_name_id
    @peer_info_name_id ||= self.class.counter
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

  def online_mark_color
    Curses::COLOR_GREEN
  end

  def online_mark_bg
    Curses::COLOR_BLACK
  end

  def peer_info_name_color
    Curses::COLOR_WHITE
  end

  def peer_info_name_bg
    Curses::COLOR_BLACK
  end
end
