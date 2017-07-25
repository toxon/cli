# frozen_string_literal: true

module Widgets
  class Menu < Base
  private

    def draw
      props[:items][props[:top]...(props[:top] + props[:height])].each_with_index.each do |item, offset|
        index = props[:top] + offset

        setpos 0, offset

        if item[:online]
          Style.default.online_mark window do
            addstr '*'
          end
        else
          addstr 'o'
        end

        addstr ' '

        Style.default.public_send(index == props[:active] && props[:focused] ? :selection : :text, window) do
          if item[:name].length <= props[:width] - 2
            addstr item[:name].ljust props[:width] - 2
          else
            addstr "#{item[:name][0...props[:width] - 5]}..."
          end
        end
      end
    end
  end
end
