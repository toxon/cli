# frozen_string_literal: true

module Widgets
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

        if friend[:status] == Tox::UserStatus::NONE
          Style.default.online_mark window do
            addstr '*'
          end
        else
          addstr 'o'
        end

        addstr ' '

        Style.default.public_send(index == props[:active] && props[:focused] ? :selection : :text, window) do
          if friend[:name].length <= props[:width] - 2
            addstr friend[:name].ljust props[:width] - 2
          else
            addstr "#{friend[:name][0...props[:width] - 5]}..."
          end
        end
      end
    end
  end
end
