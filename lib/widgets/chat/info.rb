# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    class Info < Base
      def draw
        setpos 0, 0
        Style.default.online_mark window do
          addstr '[Online]'
        end
        addstr ' '
        Style.default.peer_info_name window do
          addstr props[:name]
        end

        setpos 0, 1
        addstr 'Public key: '
        addstr props[:public_key]
      end
    end
  end
end
