# frozen_string_literal: true

module Widgets
  class Main < Container
    def trigger(event)
      case event
      when Events::Window::Left
        props[:on_window_left].call
      when Events::Window::Right
        props[:on_window_right].call
      else
        focus&.trigger event
      end
    end

    def node
      elem = render
      React::Curses::Nodes.klass_for(elem).new nil, elem
    end

    def render
      create_element :window, x: props[:x], y: props[:y], width: props[:width], height: props[:height] do
        create_element :wrapper do
          render_sidebar
          render_chat
        end
      end

      # (0...props[:height]).each do |y|
      #   setpos props[:sidebar][:width], y
      #   addstr "\u2502"
      # end
    end

    def render_sidebar
      create_element Sidebar, props[:sidebar].merge(
        on_menu_up:   props[:on_menu_up],
        on_menu_down: props[:on_menu_down],

        active_friend_index: props[:data][:active_friend_index],

        friends: props[:data][:friends],
      ).freeze
    end

    def render_chat
      create_element Chat, props[:chat].merge(
        on_new_message_enter: props[:on_new_message_enter],

        on_new_message_putc: props[:on_new_message_putc],

        on_new_message_left:  props[:on_new_message_left],
        on_new_message_right: props[:on_new_message_right],
        on_new_message_home:  props[:on_new_message_home],
        on_new_message_end:   props[:on_new_message_end],

        on_new_message_backspace: props[:on_new_message_backspace],
        on_new_message_delete:    props[:on_new_message_delete],

        active_friend_index: props[:data][:active_friend_index],

        friend: props[:data][:active_friend_index] &&
                props[:data][:friends][props[:data][:friends].keys[props[:data][:active_friend_index]]],
      ).freeze
    end

    def focus
      case props[:focus]
      when :sidebar then node.children[0].children[0].instance
      when :chat    then node.children[0].children[1].instance
      end
    end
  end
end
