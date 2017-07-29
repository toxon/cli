# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    def initialize(_parent)
      super

      @info    = Info.new       self
      @history = History.new    self
      @message = NewMessage.new self
    end

    def props=(_value)
      super

      @info.props = props[:info].merge(
        public_key:     props[:friend] ? props[:friend][:public_key]     : nil,
        name:           props[:friend] ? props[:friend][:name]           : nil,
        status:         props[:friend] ? props[:friend][:status]         : nil,
        status_message: props[:friend] ? props[:friend][:status_message] : nil,
      ).freeze

      @history.props = props[:history].merge(
        messages: props[:friend] ? props[:friend][:history] : [].freeze,
      ).freeze

      @message.props = props[:new_message].merge(
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

    def trigger(event)
      focus&.trigger event
    end

  private

    def render
      super

      setpos 0, 2
      addstr "\u2500" * props[:width]

      setpos 0, props[:height] - 2
      addstr "\u2500" * props[:width]
    end

    def focus
      case props[:focus]
      when :info        then @info
      when :history     then @history
      when :new_message then @message
      end
    end

    def children
      [@info, @history, @message]
    end
  end
end
