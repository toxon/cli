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

        offset + 1 + lines
      end
    end
  end
end
