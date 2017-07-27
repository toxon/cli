# frozen_string_literal: true

module Widgets
  using Helpers

  class Chat < VPanel
    class Info < Curses::React::Component
      PUBLIC_KEY_LABEL = 'Public key: '

    private

      def draw
        draw_main_line
        draw_public_key
      end

      def draw_main_line
        setpos 0, 0

        case props[:status]
        when Tox::UserStatus::NONE
          Style.default.online_mark window do
            addstr '[Online]'
          end
        when Tox::UserStatus::AWAY
          Style.default.away_mark window do
            addstr '[Away]'
          end
        when Tox::UserStatus::BUSY
          Style.default.busy_mark window do
            addstr '[Busy]'
          end
        else
          addstr '[Unknown]'
        end

        addstr ' '
        Style.default.peer_info_name window do
          addstr props[:name]
        end
        addstr ' : '
        addstr props[:status_message]
      end

      def draw_public_key
        setpos 0, 1
        addstr PUBLIC_KEY_LABEL
        addstr props[:public_key].ljustetc props[:width] - PUBLIC_KEY_LABEL.length
      end
    end
  end
end
