# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    class History < Base
    private

      def draw
        window.clear

        return if props[:messages].empty?

        offset = 0

        props[:messages].each do |msg|
          offset += draw_message offset, msg[:out], msg[:time].strftime('%H:%M:%S'), msg[:name], msg[:text]

          break if offset >= props[:height]
        end
      end

      def draw_message(offset, out, time, name, text)
        draw_header offset, out, time, name

        width = props[:width] / 3 * 2
        left  = out ? props[:width] - width : 0

        lines = (text.length / width.to_f).ceil

        1.upto lines do |line|
          s = text[(width * (line - 1))...(width * line)]

          if out && s.length != width
            setpos left + width - s.length, offset + line
          else
            setpos left, offset + line
          end

          addstr s
        end

        1 + lines
      end

      def draw_header(offset, out, name, time)
        if out
          setpos props[:width] - name.length - time.length - 1, offset

          Style.default.message_author window do
            addstr name
          end

          addstr ' '

          Style.default.message_time window do
            addstr time
          end
        else
          setpos 0, offset

          Style.default.message_time window do
            addstr time
          end

          addstr ' '

          Style.default.message_author window do
            addstr name
          end
        end
      end
    end
  end
end
