# frozen_string_literal: true

module Widgets
  class Chat
    attr_reader :x, :y, :width, :height
    attr_accessor :focused
    attr_reader :messages

    def initialize(x, y, width, height)
      @x = x
      @y = y

      @width  = width
      @height = height

      @focused = false

      @messages = 1.upto(100).map do
        {
          time: Faker::Time.forward,
          name: Faker::Name.name,
          text: Faker::Lorem.sentence.freeze,
        }
      end
    end

    def log_height
      height - 2
    end

    def render
      offset = 0

      messages.each do |msg|
        time = msg[:time].strftime '%H:%M:%S'
        name = msg[:name]
        text = msg[:text]

        offset = render_message offset, time, name, text

        break if offset >= log_height
      end
    end

    def render_message(offset, time, name, text)
      Curses.setpos y + offset, x

      info_length = time.length + 1 + name.length + 2
      head_length = width - info_length
      head = text[0...head_length]

      Curses.attron Curses.color_pair 6
      Curses.addstr time
      Curses.addstr ' '
      Curses.attron Curses.color_pair 7
      Curses.attron Curses::A_BOLD
      Curses.addstr name
      Curses.addstr ': '
      Curses.attroff Curses::A_BOLD
      Curses.attron Curses.color_pair 1
      Curses.addstr head

      tail_length = [0, text.length - head_length].max
      tail = text[head_length..-1]
      lines = (tail_length / width.to_f).ceil

      1.upto lines do |line|
        Curses.setpos y + offset + line, x
        Curses.addstr tail[(width * (line - 1))...(width * line)]
      end

      offset + 1 + lines
    end

    def trigger(event); end
  end
end
