# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    class History < Base
    private

      def draw
        window.clear

        return if props[:messages].empty?

        offset = 0

        props[:messages].reverse_each do |msg|
          offset += draw_message offset, msg[:out], msg[:time].strftime('%H:%M:%S'), msg[:name], msg[:text]

          break if offset >= props[:height]
        end
      end

      def draw_message(offset, out, time, name, text)
        width = props[:width] / 3 * 2
        left  = out ? props[:width] - width : 0

        lines = (text.length / width.to_f).ceil

        1.upto lines do |line|
          s = text[(width * (line - 1))...(width * line)]

          if out && s.length != width
            setpos left + width - s.length, props[:height] - offset - lines + line - 1
          else
            setpos left, props[:height] - offset - lines + line - 1
          end

          addstr s
        end

        draw_header props[:height] - offset - lines - 1, out, time, name

        1 + lines
      end

      def draw_header(y, out, name, time)
        if out
          setpos props[:width] - name.length - time.length - 1, y

          Style.default.message_time window do
            addstr time
          end

          addstr ' '

          Style.default.message_author window do
            addstr name
          end
        else
          setpos 0, y

          Style.default.message_author window do
            addstr name
          end

          addstr ' '

          Style.default.message_time window do
            addstr time
          end
        end
      end
    end
  end
end
