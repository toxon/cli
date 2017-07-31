# frozen_string_literal: true

module Widgets
  class Chat < VPanel
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
          render_info
          render_history
          render_new_message
        end
      end

      # setpos 0, 2
      # addstr "\u2500" * props[:width]

      # setpos 0, props[:height] - 2
      # addstr "\u2500" * props[:width]
    end

    def render_info
      create_element Info, props[:info].merge(
        public_key:     props[:friend] ? props[:friend][:public_key]     : nil,
        name:           props[:friend] ? props[:friend][:name]           : nil,
        status:         props[:friend] ? props[:friend][:status]         : nil,
        status_message: props[:friend] ? props[:friend][:status_message] : nil,
      ).freeze
    end

    def render_history
      create_element History, props[:history].merge(
        messages: props[:friend] ? props[:friend][:history] : [].freeze,
      ).freeze
    end

    def render_new_message
      create_element NewMessage, props[:new_message].merge(
        on_enter: props[:on_new_message_enter],

        on_putc: props[:on_new_message_putc],

        on_left:  props[:on_new_message_left],
        on_right: props[:on_new_message_right],
        on_home:  props[:on_new_message_home],
        on_end:   props[:on_new_message_end],

        on_backspace: props[:on_new_message_backspace],
        on_delete:    props[:on_new_message_delete],

        text:       props[:friend] ? props[:friend][:new_message][:text]       : '',
        cursor_pos: props[:friend] ? props[:friend][:new_message][:cursor_pos] : 0,
      ).freeze
    end

    def focus
      case props[:focus]
      when :info        then node.children[0].children[0].instance
      when :history     then node.children[0].children[1].instance
      when :new_message then node.children[0].children[2].instance
      end
    end
  end
end
