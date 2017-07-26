# frozen_string_literal: true

require 'tox'

require 'thread'

require 'faker'

require 'screen'

class Main
  SAVEDATA_FILENAME = File.expand_path '../savedata', __dir__

  def self.inherited(_base)
    raise "#{self} is final"
  end

  def self.mutex
    (@mutex ||= Mutex.new).tap { freeze }
  end

  def initialize
    raise "#{self.class} is singleton" unless self.class.mutex.try_lock
    call
  end

private

  def call
    tox_options = Tox::Options.new
    tox_options.savedata = File.binread SAVEDATA_FILENAME if File.exist? SAVEDATA_FILENAME

    @tox_client = Tox::Client.new tox_options

    on_friends_load @tox_client.friends

    @tox_client.on_iteration(&method(:on_iteration))
    @tox_client.on_friend_request(&method(:on_friend_request))
    @tox_client.on_friend_message(&method(:on_friend_message))
    @tox_client.on_friend_name_change(&method(:on_friend_name_change))
    @tox_client.on_friend_status_message_change(&method(:on_friend_status_message_change))
    @tox_client.on_friend_status_change(&method(:on_friend_status_change))

    @screen = Screen.new
    Style.default = Style.new

    @tox_client.run
  ensure
    @screen&.close
    File.binwrite SAVEDATA_FILENAME, @tox_client.savedata if @tox_client
  end

  #################
  # Tox callbacks #
  #################

  def on_iteration
    @screen.poll
    @screen.props = state
    @screen.render
  end

  def on_friends_load(friends)
    @state = state.merge(
      active_friend_index: friends.empty? ? nil : 0,

      friends: friends.map do |friend|
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

  def on_friend_request(public_key, _text)
    friend = @tox_client.friend_add_norequest public_key

    @state = state.merge(
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

  def on_friend_message(friend, text)
    @state = state.merge(
      friends: state[:friends].merge(
        friend.number => state[:friends][friend.number].merge(
          history: (state[:friends][friend.number][:history] + [
            out:  false,
            time: Time.now.utc.freeze,
            name: friend.name.freeze,
            text: text.freeze,
          ]).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def on_friend_name_change(friend, name)
    @state = @state.merge(
      friends: state[:friends].merge(
        friend.number => state[:friends][friend.number].merge(
          name: name.freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def on_friend_status_message_change(friend, status_message)
    @state = @state.merge(
      friends: state[:friends].merge(
        friend.number => state[:friends][friend.number].merge(
          status_message: status_message.freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def on_friend_status_change(friend, status)
    @state = @state.merge(
      friends: state[:friends].merge(
        friend.number => state[:friends][friend.number].merge(
          status: status,
        ).freeze,
      ).freeze,
    ).freeze
  end

  ####################
  # Screen callbacks #
  ####################

  def on_window_left
    @state = state.merge(
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

  def on_window_right
    @state = state.merge(
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

  def on_menu_up
    return if state[:active_friend_index].nil?

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

    @state = state.merge(
      active_friend_index: active_friend_index,

      sidebar: state[:sidebar].merge(
        menu: state[:sidebar][:menu].merge(
          top: top,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def on_menu_down
    return if state[:active_friend_index].nil?

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

    @state = state.merge(
      active_friend_index: active_friend_index,

      sidebar: state[:sidebar].merge(
        menu: state[:sidebar][:menu].merge(
          top: top,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def on_new_message_enter
    return if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return if friend_number.nil?

    text = state[:friends][friend_number][:new_message][:text].strip.freeze

    return if text.empty?

    @tox_client.friend(friend_number).send_message text

    @state = state.merge(
      friends: state[:friends].merge(
        friend_number => state[:friends][friend_number].merge(
          new_message: state[:friends][friend_number][:new_message].merge(
            text: '',
            cursor_pos: 0,
          ),

          history: (state[:friends][friend_number][:history] + [
            out:  true,
            time: Time.now.utc.freeze,
            name: @tox_client.name.freeze,
            text: text,
          ]).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def on_new_message_putc(char)
    return if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    text = "#{text[0...cursor_pos]}#{char}#{text[cursor_pos..-1]}"
    cursor_pos += 1

    @state = state.merge(
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

  def on_new_message_left
    return if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    cursor_pos = new_message[:cursor_pos]

    cursor_pos -= 1

    cursor_pos = 0 if cursor_pos.negative?

    @state = state.merge(
      friends: state[:friends].merge(
        friend_number => friend.merge(
          new_message: new_message.merge(
            cursor_pos: cursor_pos,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def on_new_message_right
    return if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    cursor_pos += 1

    cursor_pos = text.length if cursor_pos > text.length

    @state = state.merge(
      friends: state[:friends].merge(
        friend_number => friend.merge(
          new_message: new_message.merge(
            cursor_pos: cursor_pos,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def on_new_message_home
    return if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    @state = state.merge(
      friends: state[:friends].merge(
        friend_number => friend.merge(
          new_message: new_message.merge(
            cursor_pos: 0,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def on_new_message_end
    return if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    @state = state.merge(
      friends: state[:friends].merge(
        friend_number => friend.merge(
          new_message: new_message.merge(
            cursor_pos: new_message[:text].length,
          ).freeze,
        ).freeze,
      ).freeze,
    ).freeze
  end

  def on_new_message_backspace
    return if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    return unless cursor_pos.positive?

    text = "#{text[0...(cursor_pos - 1)]}#{text[cursor_pos..-1]}"
    cursor_pos -= 1

    @state = state.merge(
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

  def on_new_message_delete
    return if state[:active_friend_index].nil?

    friend_number = state[:friends].keys[state[:active_friend_index]]

    return if friend_number.nil?

    friend = state[:friends][friend_number]
    new_message = friend[:new_message]

    text       = new_message[:text]
    cursor_pos = new_message[:cursor_pos]

    return if cursor_pos > text.length

    text = "#{text[0...cursor_pos]}#{text[(cursor_pos + 1)..-1]}"

    @state = state.merge(
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

  #########
  # State #
  #########

  def state
    @state ||= {
      x: 0,
      y: 0,
      width: Curses.stdscr.maxx,
      height: Curses.stdscr.maxy,
      focus: :sidebar,
      focused: true,

      on_window_left:  method(:on_window_left),
      on_window_right: method(:on_window_right),

      on_menu_up:   method(:on_menu_up),
      on_menu_down: method(:on_menu_down),

      on_new_message_enter: method(:on_new_message_enter),

      on_new_message_putc: method(:on_new_message_putc),

      on_new_message_left:  method(:on_new_message_left),
      on_new_message_right: method(:on_new_message_right),
      on_new_message_home:  method(:on_new_message_home),
      on_new_message_end:   method(:on_new_message_end),

      on_new_message_backspace: method(:on_new_message_backspace),
      on_new_message_delete:    method(:on_new_message_delete),

      me: {
        public_key:     @tox_client.public_key,
        name:           @tox_client.name,
        status:         @tox_client.status,
        status_message: @tox_client.status_message,
      },

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
        x: Widgets::Logo::WIDTH,
        y: 0,
        width: Curses.stdscr.maxx - Widgets::Logo::WIDTH,
        height: Curses.stdscr.maxy,
        focus: :new_message,
        focused: false,

        info: {
          x: Widgets::Logo::WIDTH,
          y: 0,
          width: Curses.stdscr.maxx - Widgets::Logo::WIDTH,
          height: 2,
          focused: false,
        }.freeze,

        new_message: {
          x: Widgets::Logo::WIDTH,
          y: Curses.stdscr.maxy - 1,
          width: Curses.stdscr.maxx - Widgets::Logo::WIDTH,
          height: 1,
          focused: false,
        }.freeze,

        history: {
          x: Widgets::Logo::WIDTH,
          y: 2,
          width: Curses.stdscr.maxx - Widgets::Logo::WIDTH,
          height: Curses.stdscr.maxy - 3,
          focused: true,
        }.freeze,
      }.freeze,
    }.freeze
  end
end
