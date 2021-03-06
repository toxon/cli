# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    class Info < React::Component
      PUBLIC_KEY_LABEL = 'Public key: '

      def render
        create_element :window, x: props[:x], y: props[:y], width: props[:width], height: props[:height] do
          create_element :lines do
            create_element :line do
              create_element :text, text: status_text, attr: status_attr
              create_element :text, text: ' '
              create_element :text, text: props[:name], attr: Style.default.peer_info_name_attr
              create_element :text, text: ' : '
              create_element :text, text: props[:status_message]
            end

            create_element :line do
              create_element :text, text: PUBLIC_KEY_LABEL
              create_element :text, text: props[:public_key]
            end
          end
        end
      end

      def status_text
        case props[:status]
        when Tox::UserStatus::NONE then '[Online]'
        when Tox::UserStatus::AWAY then '[Away]'
        when Tox::UserStatus::BUSY then '[Busy]'
        else '[Unknown]'
        end
      end

      def status_attr
        case props[:status]
        when Tox::UserStatus::NONE then Style.default.online_mark_attr
        when Tox::UserStatus::AWAY then Style.default.away_mark_attr
        when Tox::UserStatus::BUSY then Style.default.busy_mark_attr
        end
      end
    end
  end
end
