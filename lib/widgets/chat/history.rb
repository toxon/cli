# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    class History < React::Component
      def render
        create_element :window, x: props[:x], y: props[:y], width: props[:width], height: props[:height] do
          create_element :lines do
            offset = 0

            props[:messages].reverse_each do |msg|
              lines = (msg[:text].length / message_block_width.to_f).ceil
              x = msg[:out] ? props[:width] - message_block_width : 0
              y = props[:height] - offset - lines - 1

              render_message(
                msg[:out],
                msg[:error],
                msg[:text],
                msg[:name],
                msg[:time].strftime('%H:%M:%S'),
                lines,
                x: x,
                y: y,
              )

              offset += 1 + lines

              break if offset >= props[:height]
            end
          end
        end
      end

      def render_message(out, error, text, name, time, lines, x:, y:)
        text_width = name.length + time.length + (error ? 3 : 1)

        create_element :line, x: out ? x : 0, y: y, rjust: out do
          if out
            create_element :text, text: ' ' * (message_block_width - text_width)

            if error
              create_element :text, text: 'x', attr: Style.default.message_error_attr
              create_element :text, text: ' '
            end

            create_element :text, text: name, attr: Style.default.message_author_attr
            create_element :text, text: ' '
            create_element :text, text: time, attr: Style.default.message_time_attr
          else
            create_element :text, text: time, attr: Style.default.message_time_attr
            create_element :text, text: ' '
            create_element :text, text: name, attr: Style.default.message_author_attr

            if error
              create_element :text, text: ' '
              create_element :text, text: 'x', attr: Style.default.message_error_attr
            end
          end
        end

        1.upto lines do |line|
          create_element :line, x: out ? x : 0, y: y + line, rjust: out do
            s = text[(message_block_width * (line - 1))...(message_block_width * line)].strip
            create_element :text, text: out ? s.rjust(message_block_width) : s
          end
        end
      end

      def message_block_width
        props[:width] / 3 * 2
      end
    end
  end
end
