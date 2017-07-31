# frozen_string_literal: true

module Widgets
  using Helpers

  class Menu < React::Component
    def trigger(event)
      case event
      when Events::Text::Up
        props[:on_up].call
      when Events::Text::Down
        props[:on_down].call
      end
    end

    def draw
      elem = render
      React::Curses::Nodes.klass_for(elem).new(nil, elem).draw
    end

    def render
      create_element :window, x: props[:x], y: props[:y], width: props[:width], height: props[:height] do
        create_element :lines do
          props[:friends].values[props[:top]...(props[:top] + props[:height])].each_with_index.each do |friend, offset|
            create_element :line do
              index = props[:top] + offset

              case friend[:status]
              when Tox::UserStatus::NONE
                create_element :text, text: '*', attr: Style.default.online_mark_attr
              when Tox::UserStatus::AWAY
                create_element :text, text: '*', attr: Style.default.away_mark_attr
              when Tox::UserStatus::BUSY
                create_element :text, text: '*', attr: Style.default.busy_mark_attr
              else
                create_element :text, text: 'o'
              end

              create_element :text, text: ' '

              create_element(
                :text,
                text: friend[:name].ljustetc(props[:width] - 2),
                attr: if index == props[:active_friend_index] && props[:focused]
                        Style.default.selection_attr
                      else
                        Style.default.text_attr
                      end,
              )
            end
          end
        end
      end
    end
  end
end
