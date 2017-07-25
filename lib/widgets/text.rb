# frozen_string_literal: true

module Widgets
  class Text < Base
    def draw
      total = props[:width] - 1
      start = [0, props[:cursor_pos] - total].max

      cut = props[:text][start...start + total]

      setpos 0, 0

      before_cursor = cut[0...props[:cursor_pos]]
      under_cursor  = cut[props[:cursor_pos]] || ' '
      after_cursor  = cut[(1 + props[:cursor_pos])..-1] || ''

      Style.default.editing_text window do
        addstr before_cursor
      end

      Style.default.public_send props[:focused] ? :cursor : :editing_text, window do
        addstr under_cursor
      end

      Style.default.editing_text window do
        addstr after_cursor
      end
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
