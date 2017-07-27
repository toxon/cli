# frozen_string_literal: true

module Widgets
  class Text < Curses::React::Component
    def trigger(event)
      case event
      when Events::Text::Enter
        props[:on_enter].call

      when Events::Text::Putc
        props[:on_putc].call event.char

      when Events::Text::Left
        props[:on_left].call
      when Events::Text::Right
        props[:on_right].call
      when Events::Text::Home
        props[:on_home].call
      when Events::Text::End
        props[:on_end].call

      when Events::Text::Backspace
        props[:on_backspace].call
      when Events::Text::Delete
        props[:on_delete].call
      end
    end

  private

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
  end
end
