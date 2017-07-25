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
      ).freeze

      @chat.props = props[:chat].merge(
        on_new_message_putc: props[:on_new_message_putc],
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
