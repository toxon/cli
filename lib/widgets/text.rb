# frozen_string_literal: true

module Widgets
  class Text < React::Component
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

    def draw
      elem = render
      React::Curses::Nodes.klass_for(elem).new(parent, elem).draw
    end

  private

    def total
      props[:width] - 1
    end

    def start
      [0, props[:cursor_pos] - total].max
    end

    def cut
      props[:text][start...start + total]
    end

    def before_cursor
      cut[0...props[:cursor_pos]]
    end

    def under_cursor
      cut[props[:cursor_pos]] || ' '
    end

    def after_cursor
      cut[(1 + props[:cursor_pos])..-1] || ''
    end

    def render
      create_element :window, x: props[:x], y: props[:y], width: props[:width], height: props[:height] do
        create_element :lines do
          create_element :line do
            create_element :text, text: before_cursor, attr: Style.default.editing_text_attr

            create_element :text,
                           text: under_cursor,
                           attr: props[:focused] ? Style.default.cursor_attr : Style.default.editing_text_attr

            create_element :text, text: after_cursor, attr: Style.default.editing_text_attr
          end
        end
      end
    end
  end
end
