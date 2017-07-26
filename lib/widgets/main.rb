# frozen_string_literal: true

module Widgets
  class Main < Container
    def initialize(_parent)
      super

      @sidebar = Widgets::Sidebar.new self
      @chat    = Widgets::Chat.new    self
    end

    def props=(_value)
      super

      @sidebar.props = props[:sidebar].merge(
        on_menu_up:   props[:on_menu_up],
        on_menu_down: props[:on_menu_down],

        active_friend_index: props[:active_friend_index],

        friends: props[:friends],
      ).freeze

      @chat.props = props[:chat].merge(
        on_new_message_enter: props[:on_new_message_enter],

        on_new_message_putc: props[:on_new_message_putc],

        on_new_message_left:  props[:on_new_message_left],
        on_new_message_right: props[:on_new_message_right],
        on_new_message_home:  props[:on_new_message_home],
        on_new_message_end:   props[:on_new_message_end],

        on_new_message_backspace: props[:on_new_message_backspace],
        on_new_message_delete:    props[:on_new_message_delete],

        active_friend_index: props[:active_friend_index],

        friend: props[:active_friend_index] && props[:friends][props[:friends].keys[props[:active_friend_index]]],
      ).freeze
    end

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

  private

    def draw
      super

      (0...props[:height]).each do |y|
        setpos props[:sidebar][:width], y
        addstr '|'
      end
    end

    def focus
      case props[:focus]
      when :sidebar then @sidebar
      when :chat    then @chat
      end
    end

    def children
      [@sidebar, @chat]
    end
  end
end
