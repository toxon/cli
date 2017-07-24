# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    class History < Base
      def messages
        props[:messages]
      end

      def draw
        offset = 0

        messages.each do |msg|
          offset += draw_message offset, msg[:out], msg[:time].strftime('%H:%M:%S'), msg[:name], msg[:text]

          break if offset >= height
        end
      end

      def draw_message(offset, _out, time, name, text)
        setpos 0, offset

        Style.default.message_time window do
          addstr time
        end

        addstr ' '

        Style.default.message_author window do
          addstr name
        end

        lines = (text.length / width.to_f).ceil

        1.upto lines do |line|
          setpos 0, offset + line
          addstr text[(width * (line - 1))...(width * line)]
        end

        1 + lines
      end
    end
  end
end
