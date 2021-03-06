# frozen_string_literal: true

require 'reducers/data'

class Reducer < Obredux::Reducer
  combine data: Reducers::Data

  class << self
    attr_reader :screen_width, :screen_height

    def screen_width=(value)
      raise TypeError,     "expected screen width to be an #{Integer}"                 unless value.is_a? Integer
      raise ArgumentError, 'expected screen width to be greater than or equal to zero' unless value >= 0
      @screen_width = value
    end

    def screen_height=(value)
      raise TypeError,     "expected screen height to be an #{Integer}"                 unless value.is_a? Integer
      raise ArgumentError, 'expected screen height to be greater than or equal to zero' unless value >= 0
      @screen_height = value
    end
  end

private

  def initial_state
    {
      x: 0,
      y: 0,
      width: self.class.screen_width,
      height: self.class.screen_height,
      focus: :sidebar,
      focused: true,

      sidebar: {
        x: 0,
        y: 0,
        width: Widgets::Logo::WIDTH,
        height: self.class.screen_height,
        focus: :menu,
        focused: true,

        logo: {
          x: 0,
          y: 0,
          width: Widgets::Logo::WIDTH,
          height: Widgets::Logo::HEIGHT,
        }.freeze,

        menu: {
          x: 0,
          y: Widgets::Logo::HEIGHT,
          width: Widgets::Logo::WIDTH,
          height: self.class.screen_height - Widgets::Logo::HEIGHT,
          focused: true,

          active: 0,
          top: 0,
        }.freeze,
      }.freeze,

      chat: {
        x: Widgets::Logo::WIDTH + 1,
        y: 0,
        width: self.class.screen_width - Widgets::Logo::WIDTH - 1,
        height: self.class.screen_height,
        focus: :new_message,
        focused: false,

        info: {
          x: Widgets::Logo::WIDTH + 1,
          y: 0,
          width: self.class.screen_width - Widgets::Logo::WIDTH - 1,
          height: 2,
          focused: false,
        }.freeze,

        new_message: {
          x: Widgets::Logo::WIDTH + 1,
          y: self.class.screen_height - 1,
          width: self.class.screen_width - Widgets::Logo::WIDTH - 1,
          height: 1,
          focused: false,
        }.freeze,

        history: {
          x: Widgets::Logo::WIDTH + 1,
          y: 3,
          width: self.class.screen_width - Widgets::Logo::WIDTH - 1,
          height: self.class.screen_height - 5,
          focused: true,
        }.freeze,
      }.freeze,
    }.freeze
  end

  def reduce
    case action
    when Actions::WindowLeft
      window_left
    when Actions::WindowRight
      window_right
    when Actions::MenuUp
      menu_up
    when Actions::MenuDown
      menu_down
    when Actions::NewMessagePutc
      new_message_putc
    when Actions::NewMessageLeft
      new_message_left
    when Actions::NewMessageRight
      new_message_right
    when Actions::NewMessageHome
      new_message_home
    when Actions::NewMessageEnd
      new_message_end
    when Actions::NewMessageBackspace
      new_message_backspace
    when Actions::NewMessageDelete
      new_message_delete
    else
      state
    end
  end

  def window_left
    state.merge(
      focus: :sidebar,

      sidebar: state[:sidebar].merge(
        focused: true,

        logo: state[:sidebar][:logo].merge(focused: state[:sidebar][:focus] == :logo).freeze,
        menu: state[:sidebar][:menu].merge(focused: state[:sidebar][:focus] == :menu).freeze,
      ).freeze,

      chat: state[:chat].merge(
        focused: false,

        info:               state[:chat][:info].merge(focused: false).freeze,
        new_message: state[:chat][:new_message].merge(focused: false).freeze,
        history:         state[:chat][:history].merge(focused: false).freeze,
      ).freeze,
    ).freeze
  end

  def window_right
    state.merge(
      focus: :chat,

      sidebar: state[:sidebar].merge(
        focused: true,

        logo: state[:sidebar][:logo].merge(focused: false).freeze,
        menu: state[:sidebar][:menu].merge(focused: false).freeze,
      ).freeze,

      chat: state[:chat].merge(
        focused: false,

        info:               state[:chat][:info].merge(focused: state[:chat][:focus] == :info).freeze,
        new_message: state[:chat][:new_message].merge(focused: state[:chat][:focus] == :new_message).freeze,
        history:         state[:chat][:history].merge(focused: state[:chat][:focus] == :history).freeze,
      ).freeze,
    ).freeze
  end

  def menu_up
    return state if state[:data][:active_friend_index].nil?

    active_friend_index = state[:data][:active_friend_index] + 1
    top = state[:sidebar][:menu][:top]

    if active_friend_index.negative?
      active_friend_index = state[:data][:friends].count - 1
    elsif active_friend_index >= state[:data][:friends].count
      active_friend_index = 0
    end

    if active_friend_index < top
      top = active_friend_index
    elsif active_friend_index >= top + state[:height]
      top = active_friend_index - state[:height] + 1
    end

    state.merge(
      data: state[:data].merge(
        active_friend_index: active_friend_index,
      ).freeze,

      sidebar: state[:sidebar].merge(
        menu: state[:sidebar][:menu].merge(
          top: top,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def menu_down
    return state if state[:data][:active_friend_index].nil?

    active_friend_index = state[:data][:active_friend_index] + 1
    top = state[:sidebar][:menu][:top]

    if active_friend_index.negative?
      active_friend_index = state[:data][:friends].count - 1
    elsif active_friend_index >= state[:data][:friends].count
      active_friend_index = 0
    end

    if active_friend_index < top
      top = active_friend_index
    elsif active_friend_index >= top + state[:height]
      top = active_friend_index - state[:height] + 1
    end

    state.merge(
      data: state[:data].merge(
        active_friend_index: active_friend_index,
      ).freeze,

      sidebar: state[:sidebar].merge(
        menu: state[:sidebar][:menu].merge(
          top: top,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def new_message_putc
    return state if state[:data][:active_friend_index].nil?

    friend_number = state[:data][:friends].keys[state[:data][:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:data][:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    text = "#{text[0...cursor_pos]}#{action.char}#{text[cursor_pos..-1]}"
    cursor_pos += 1

    state.merge(
      data: state[:data].merge(
        friends: state[:data][:friends].merge(
          friend_number => friend.merge(
            new_message: new_message.merge(
              text: text,
              cursor_pos: cursor_pos,
            ).freeze,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def new_message_left
    return state if state[:data][:active_friend_index].nil?

    friend_number = state[:data][:friends].keys[state[:data][:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:data][:friends][friend_number]
    new_message = friend[:new_message]

    cursor_pos = new_message[:cursor_pos]

    cursor_pos -= 1

    cursor_pos = 0 if cursor_pos.negative?

    state.merge(
      data: state[:data].merge(
        friends: state[:data][:friends].merge(
          friend_number => friend.merge(
            new_message: new_message.merge(
              cursor_pos: cursor_pos,
            ).freeze,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def new_message_right
    return state if state[:data][:active_friend_index].nil?

    friend_number = state[:data][:friends].keys[state[:data][:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:data][:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    cursor_pos += 1

    cursor_pos = text.length if cursor_pos > text.length

    state.merge(
      data: state[:data].merge(
        friends: state[:data][:friends].merge(
          friend_number => friend.merge(
            new_message: new_message.merge(
              cursor_pos: cursor_pos,
            ).freeze,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def new_message_home
    return state if state[:data][:active_friend_index].nil?

    friend_number = state[:data][:friends].keys[state[:data][:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:data][:friends][friend_number]
    new_message = friend[:new_message]

    state.merge(
      data: state[:data].merge(
        friends: state[:data][:friends].merge(
          friend_number => friend.merge(
            new_message: new_message.merge(
              cursor_pos: 0,
            ).freeze,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def new_message_end
    return state if state[:data][:active_friend_index].nil?

    friend_number = state[:data][:friends].keys[state[:data][:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:data][:friends][friend_number]
    new_message = friend[:new_message]

    state.merge(
      data: state[:data].merge(
        friends: state[:data][:friends].merge(
          friend_number => friend.merge(
            new_message: new_message.merge(
              cursor_pos: new_message[:text].length,
            ).freeze,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def new_message_backspace
    return state if state[:data][:active_friend_index].nil?

    friend_number = state[:data][:friends].keys[state[:data][:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:data][:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    return state unless cursor_pos.positive?

    text = "#{text[0...(cursor_pos - 1)]}#{text[cursor_pos..-1]}"
    cursor_pos -= 1

    state.merge(
      data: state[:data].merge(
        friends: state[:data][:friends].merge(
          friend_number => friend.merge(
            new_message: new_message.merge(
              text:       text,
              cursor_pos: cursor_pos,
            ).freeze,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def new_message_delete
    return state if state[:data][:active_friend_index].nil?

    friend_number = state[:data][:friends].keys[state[:data][:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:data][:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    return state if cursor_pos > text.length

    text = "#{text[0...cursor_pos]}#{text[(cursor_pos + 1)..-1]}"

    state.merge(
      data: state[:data].merge(
        friends: state[:data][:friends].merge(
          friend_number => friend.merge(
            new_message: new_message.merge(
              text:       text,
              cursor_pos: cursor_pos,
            ).freeze,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end
end
