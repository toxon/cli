# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    class Info < Base
    private

      def draw
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

        setpos 0, 1
        addstr 'Public key: '
        addstr props[:public_key]
      end
    end
  end
end
