# frozen_string_literal: true

module Widgets
  class Sidebar < Container
    def trigger(event)
      focus&.trigger event
    end

    def draw
      node.draw
    end

    def node
      elem = render
      React::Curses::Nodes.klass_for(elem).new nil, elem
    end

    def render
      create_element :window, x: props[:x], y: props[:y], width: props[:width], height: props[:height] do
        create_element :wrapper do
          create_element Logo, props[:logo]
          render_menu
        end
      end
    end

    def render_menu
      create_element Menu, props[:menu].merge(
        on_up:   props[:on_menu_up],
        on_down: props[:on_menu_down],

        active_friend_index: props[:active_friend_index],

        friends: props[:friends],
      ).freeze
    end

    def focus
      case props[:focus]
      when :menu then node.children[0].children[1].instance
      end
    end
  end
end
