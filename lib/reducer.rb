# frozen_string_literal: true

module Reducer
  def self.initial_state
    {
      x: 0,
      y: 0,
      width: Curses.stdscr.maxx,
      height: Curses.stdscr.maxy,
      focus: :sidebar,
      focused: true,

      active_friend_index: nil,

      friends: {}.freeze,

      sidebar: {
        x: 0,
        y: 0,
        width: Widgets::Logo::WIDTH,
        height: Curses.stdscr.maxy,
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
          height: Curses.stdscr.maxy - Widgets::Logo::HEIGHT,
          focused: true,

          active: 0,
          top: 0,
        }.freeze,
      }.freeze,

      chat: {
        x: Widgets::Logo::WIDTH + 1,
        y: 0,
        width: Curses.stdscr.maxx - Widgets::Logo::WIDTH - 1,
        height: Curses.stdscr.maxy,
        focus: :new_message,
        focused: false,

        info: {
          x: Widgets::Logo::WIDTH + 1,
          y: 0,
          width: Curses.stdscr.maxx - Widgets::Logo::WIDTH - 1,
          height: 2,
          focused: false,
        }.freeze,

        new_message: {
          x: Widgets::Logo::WIDTH + 1,
          y: Curses.stdscr.maxy - 1,
          width: Curses.stdscr.maxx - Widgets::Logo::WIDTH - 1,
          height: 1,
          focused: false,
        }.freeze,

        history: {
          x: Widgets::Logo::WIDTH + 1,
          y: 3,
          width: Curses.stdscr.maxx - Widgets::Logo::WIDTH - 1,
          height: Curses.stdscr.maxy - 5,
          focused: true,
        }.freeze,
      }.freeze,
    }.freeze
  end

  def self.call(state, action)
    state = initial_state if state == Obredux::UNDEFINED

    case action
    when Actions::LoadFriends
      load_friends state, action
    when Actions::FriendRequest
      friend_request state, action
    when Actions::FriendMessage
      friend_message state, action
    when Actions::ChangeFriendName
      change_friend_name state, action
    when Actions::ChangeFriendStatusMessage
      change_friend_status_message state, action
    when Actions::ChangeFriendStatus
      change_friend_status state, action
    when Actions::WindowLeft
      window_left state, action
    when Actions::WindowRight
      window_right state, action
    when Actions::MenuUp
      menu_up state, action
    when Actions::MenuDown
      menu_down state, action
    when Actions::NewMessageEnter
      new_message_enter state, action
    when Actions::NewMessagePutc
      new_message_putc state, action
    when Actions::NewMessageLeft
      new_message_left state, action
    when Actions::NewMessageRight
      new_message_right state, action
    when Actions::NewMessageHome
      new_message_home state, action
    when Actions::NewMessageEnd
      new_message_end state, action
    when Actions::NewMessageBackspace
      new_message_backspace state, action
    when Actions::NewMessageDelete
      new_message_delete state, action
    else
      state
    end
  end

  def self.load_friends(state, action)
    state.merge(
      active_friend_index: action.friends.empty? ? nil : 0,
      friends: action.friends.map do |friend|
        [
          friend.number,
          public_key:     friend.public_key.to_hex.freeze,
          name:           friend.name.freeze,
          status:         friend.status,
          status_message: friend.status_message.freeze,
          history:        [].freeze,
          new_message: {
            text: '',
            cursor_pos: 0,
          }.freeze,
        ]
      end.to_h.freeze,
    ).freeze
  end

  def self.friend_request(state, action)
    friend = action.tox_client.friend_add_norequest action.public_key

    state.merge(
      active_friend_index: state[:active_friend_index] || state[:friends].count,

      friends: state[:friends].merge(
        friend.number => {
          public_key:     friend.public_key.to_hex.freeze,
          name:           friend.name.freeze,
          status:         friend.status,
          status_message: friend.status_message.freeze,
          history:        [].freeze,
          new_message: {
            text: '',
            cursor_pos: 0,
          }.freeze,
        }.freeze,
      ).freeze,
    ).freeze
  end

  def self.friend_message(state, action)
    state.merge(
      friends: state[:friends].merge(
        action.friend.number => state[:friends][action.friend.number].merge(
          history: (state[:friends][action.friend.number][:history] + [
            out:  false,
            time: Time.now.utc.freeze,
            name: action.friend.name.freeze,
            text: action.text.freeze,
          ]).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.change_friend_name(state, action)
    state.merge(
      friends: state[:friends].merge(
        action.friend.number => state[:friends][action.friend.number].merge(
          name: action.new_name.freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.change_friend_status_message(state, action)
    state.merge(
      friends: state[:friends].merge(
        action.friend.number => state[:friends][action.friend.number].merge(
          status_message: action.new_status_message.freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.change_friend_status(state, action)
    state.merge(
      friends: state[:friends].merge(
        action.friend.number => state[:friends][action.friend.number].merge(
          status: action.new_status,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.window_left(state, _action)
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

  def self.window_right(state, _action)
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

  def self.menu_up(state, _action)
    return state if state[:active_friend_index].nil?

    active_friend_index = state[:active_friend_index] + 1
    top = state[:sidebar][:menu][:top]

    if active_friend_index.negative?
      active_friend_index = state[:friends].count - 1
    elsif active_friend_index >= state[:friends].count
      active_friend_index = 0
    end

    if active_friend_index < top
      top = active_friend_index
    elsif active_friend_index >= top + state[:height]
      top = active_friend_index - state[:height] + 1
    end

    state.merge(
      active_friend_index: active_friend_index,

      sidebar: state[:sidebar].merge(
        menu: state[:sidebar][:menu].merge(
          top: top,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.menu_down(state, _action)
    return state if state[:active_friend_index].nil?

    active_friend_index = state[:active_friend_index] + 1
    top = state[:sidebar][:menu][:top]

    if active_friend_index.negative?
      active_friend_index = state[:friends].count - 1
    elsif active_friend_index >= state[:friends].count
      active_friend_index = 0
    end

    if active_friend_index < top
      top = active_friend_index
    elsif active_friend_index >= top + state[:height]
      top = active_friend_index - state[:height] + 1
    end

    state.merge(
      active_friend_index: active_friend_index,

      sidebar: state[:sidebar].merge(
        menu: state[:sidebar][:menu].merge(
          top: top,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.new_message_enter(state, action)
    return state if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return state if friend_number.nil?

    text = state[:friends][friend_number][:new_message][:text].strip.freeze

    return state if text.empty?

    error = false

    begin
      action.tox_client.friend(friend_number).send_message text
    rescue
      error = true
    end

    state.merge(
      friends: state[:friends].merge(
        friend_number => state[:friends][friend_number].merge(
          new_message: state[:friends][friend_number][:new_message].merge(
            text: '',
            cursor_pos: 0,
          ),

          history: (state[:friends][friend_number][:history] + [
            error:    error,
            out:      true,
            received: false,
            time:     Time.now.utc.freeze,
            name:     action.tox_client.name.freeze,
            text:     text,
          ]).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.new_message_putc(state, action)
    return state if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    text = "#{text[0...cursor_pos]}#{action.char}#{text[cursor_pos..-1]}"
    cursor_pos += 1

    state.merge(
      friends: state[:friends].merge(
        friend_number => friend.merge(
          new_message: new_message.merge(
            text: text,
            cursor_pos: cursor_pos,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.new_message_left(state, _action)
    return state if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    cursor_pos = new_message[:cursor_pos]

    cursor_pos -= 1

    cursor_pos = 0 if cursor_pos.negative?

    state.merge(
      friends: state[:friends].merge(
        friend_number => friend.merge(
          new_message: new_message.merge(
            cursor_pos: cursor_pos,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.new_message_right(state, _action)
    return state if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    cursor_pos += 1

    cursor_pos = text.length if cursor_pos > text.length

    state.merge(
      friends: state[:friends].merge(
        friend_number => friend.merge(
          new_message: new_message.merge(
            cursor_pos: cursor_pos,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.new_message_home(state, _action)
    return state if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    state.merge(
      friends: state[:friends].merge(
        friend_number => friend.merge(
          new_message: new_message.merge(
            cursor_pos: 0,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.new_message_end(state, _action)
    return state if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    state.merge(
      friends: state[:friends].merge(
        friend_number => friend.merge(
          new_message: new_message.merge(
            cursor_pos: new_message[:text].length,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.new_message_backspace(state, _action)
    return state if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    return state unless cursor_pos.positive?

    text = "#{text[0...(cursor_pos - 1)]}#{text[cursor_pos..-1]}"
    cursor_pos -= 1

    state.merge(
      friends: state[:friends].merge(
        friend_number => friend.merge(
          new_message: new_message.merge(
            text:       text,
            cursor_pos: cursor_pos,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def self.new_message_delete(state, _action)
    return state if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return state if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    return state if cursor_pos > text.length

    text = "#{text[0...cursor_pos]}#{text[(cursor_pos + 1)..-1]}"

    state.merge(
      friends: state[:friends].merge(
        friend_number => friend.merge(
          new_message: new_message.merge(
            text:       text,
            cursor_pos: cursor_pos,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end
end