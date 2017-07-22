# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    class Info < Base
      attr_reader :name, :public_key

      def initialize(x, y, width, height)
        super

        @name = Faker::Name.name
        @public_key = SecureRandom.hex 32
      end

      def draw
        Curses.setpos y, x
        Style.default.online_mark do
          Curses.addstr '[Online]'
        end
        Curses.addstr ' '
        Style.default.peer_info_name do
          Curses.addstr name
        end

        Curses.setpos y + 1, x
        Curses.addstr 'Public key: '
        Curses.addstr public_key
      end
    end
  end
end
