# frozen_string_literal: true

module Widgets
  using Helpers

  class Menu < Base
    def trigger(event)
      case event
      when Events::Text::Up
        props[:on_up].call
      when Events::Text::Down
        props[:on_down].call
      end
    end

  private

    def draw
      return if props[:friends].empty?

      props[:friends].values[props[:top]...(props[:top] + props[:height])].each_with_index.each do |friend, offset|
        index = props[:top] + offset

        setpos 0, offset

        case friend[:status]
        when Tox::UserStatus::NONE
          Style.default.online_mark window do
            addstr '*'
          end
        when Tox::UserStatus::AWAY
          Style.default.away_mark window do
            addstr '*'
          end
        when Tox::UserStatus::BUSY
          Style.default.busy_mark window do
            addstr '*'
          end
        else
          addstr 'o'
        end

        addstr ' '

        Style.default.public_send(
          if index == props[:active_friend_index] && props[:focused]
            :selection
          else
            :text
          end,
          window,
        ) do
          addstr friend[:name].ljustetc props[:width] - 2
        end
      end
    end
  end
end
