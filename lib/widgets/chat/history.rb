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

      def draw_message(offset, _out, time, name, text)
        setpos 0, offset

        Style.default.message_time window do
          addstr time
        end

        addstr ' '

        Style.default.message_author window do
          addstr name
        end

        lines = (text.length / props[:width].to_f).ceil

        1.upto lines do |line|
          setpos 0, offset + line
          addstr text[(props[:width] * (line - 1))...(props[:width] * line)]
        end

        1 + lines
      end
    end
  end
end
