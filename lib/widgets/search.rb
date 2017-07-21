# frozen_string_literal: true

module Widgets
  class Search
    attr_reader :x, :y, :width, :height, :text, :cursor_pos
    attr_accessor :focused

    def initialize(x, y, width, height)
      @x = x
      @y = y
      @width = width
      @height = height
      @text = ''
      @cursor_pos = 0
      @focused = false
    end

    def render
      total = width - 1
      start = [0, cursor_pos - total].max

      cut = text[start...start + total]

      Curses.setpos y, x

      before_cursor = cut[0...cursor_pos]
      under_cursor  = cut[cursor_pos] || ' '
      after_cursor  = cut[(1 + cursor_pos)..-1] || ''

      Curses.attron Curses.color_pair 3
      Curses.addstr before_cursor

      Curses.attron Curses.color_pair 4 if focused
      Curses.addstr under_cursor

      Curses.attron Curses.color_pair 3
      Curses.addstr after_cursor
    end

    def trigger(event)
      case event
      when Events::Text::Putc
        putc event.char
      when Events::Text::Left
        left
      when Events::Text::Right
        right
      when Events::Text::Home
        home
      when Events::Text::End
        endk
      when Events::Text::Backspace
        backspace
      when Events::Text::Delete
        delete
      end
    end

    def putc(c)
      @text = "#{text[0...cursor_pos]}#{c}#{text[cursor_pos..-1]}"
      @cursor_pos += 1
      update
    end

    def left
      @cursor_pos -= 1
      update
    end

    def right
      @cursor_pos += 1
      update
    end

    def home
      @cursor_pos = 0
    end

    def endk
      @cursor_pos = @text.length
    end

    def backspace
      return unless cursor_pos.positive?
      @text = "#{text[0...(cursor_pos - 1)]}#{text[cursor_pos..-1]}"
      @cursor_pos -= 1
      update
    end

    def delete
      return if cursor_pos > text.length
      @text = "#{text[0...cursor_pos]}#{text[(cursor_pos + 1)..-1]}"
    end

    def update
      if @cursor_pos.negative?
        @cursor_pos = 0
      elsif @cursor_pos > @text.length
        @cursor_pos = @text.length
      end
    end
  end
end
