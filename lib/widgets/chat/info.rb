# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    class Info < Base
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
        if PUBLIC_KEY_LABEL.length + props[:public_key].length > props[:width]
          width = props[:width] - PUBLIC_KEY_LABEL.length
          addstr "#{props[:public_key][0...(width - 3)]}..."
        else
          addstr props[:public_key]
        end
      end
    end
  end
end
