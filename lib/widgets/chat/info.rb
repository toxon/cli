# frozen_string_literal: true

module Widgets
  using Helpers

  class Chat < VPanel
    class Info < Curses::React::Component
      PUBLIC_KEY_LABEL = 'Public key: '

    private

      def render
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

        Curses::React::Nodes.create(
          create_element(:wrapper) do
            create_element :text_line,
                           x: 0,
                           y: 1,
                           width: PUBLIC_KEY_LABEL.length,
                           text: PUBLIC_KEY_LABEL

            create_element :text_line,
                           x: PUBLIC_KEY_LABEL.length,
                           y: 1,
                           width: props[:width] - PUBLIC_KEY_LABEL.length,
                           text: props[:public_key]
          end,

          window,
        ).draw
      end
    end
  end
end
