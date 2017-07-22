# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    class History < Base
      attr_reader :messages

      def initialize(x, y, width, height)
        super

        @messages = 1.upto(100).map do
          {
            time: Faker::Time.forward,
            name: Faker::Name.name,
            text: Faker::Lorem.sentence.freeze,
          }
        end
      end

      def draw
        offset = 0

        messages.each do |msg|
          time = msg[:time].strftime '%H:%M:%S'
          name = msg[:name]
          text = msg[:text]

          offset = draw_message offset, time, name, text

          break if offset >= height
        end
      end

      def draw_message(offset, time, name, text)
        Curses.setpos y + offset, x

        info_length = time.length + 1 + name.length + 2
        head_length = width - info_length
        head = text[0...head_length]

        Style.default.message_time do
          Curses.addstr time
        end

        Curses.addstr ' '

        Style.default.message_author do
          Curses.addstr name
          Curses.addstr ': '
        end

        Style.default.text do
          Curses.addstr head
        end

        tail_length = [0, text.length - head_length].max
        tail = text[head_length..-1]
        lines = (tail_length / width.to_f).ceil

        1.upto lines do |line|
          Curses.setpos y + offset + line, x
          Curses.addstr tail[(width * (line - 1))...(width * line)]
        end

        offset + 1 + lines
      end
    end
  end
end
