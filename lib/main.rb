# frozen_string_literal: true

require 'tox'

require 'singleton'

require 'helpers'
require 'actions'
require 'reducer'
require 'screen'

class Main
  include Singleton

  SAVEDATA_FILENAME = File.expand_path '../savedata', __dir__

  def initialize
    call
  end

private

  def store
    @store ||= Obredux::Store.new Reducer
  end

  def state
    store.state.merge(
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
    ).freeze
  end

  def call
    @screen = Screen.new
    Style.default = Style.new

    Reducer.screen_width  = Curses.stdscr.maxx
    Reducer.screen_height = Curses.stdscr.maxy

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
    @screen.draw
  end

  def on_friends_load(friends)
    store.dispatch Actions::LoadFriends.new friends
  end

  def on_friend_request(public_key, _text)
    friend = @tox_client.friend_add_norequest public_key

    store.dispatch Actions::AddFriend.new friend
  end

  def on_friend_message(friend, text)
    store.dispatch Actions::AddFriendMessage.new friend, text
  end

  def on_friend_name_change(friend, name)
    store.dispatch Actions::ChangeFriendName.new friend, name
  end

  def on_friend_status_message_change(friend, status_message)
    store.dispatch Actions::ChangeFriendStatusMessage.new friend, status_message
  end

  def on_friend_status_change(friend, status)
    store.dispatch Actions::ChangeFriendStatus.new friend, status
  end

  ####################
  # Screen callbacks #
  ####################

  def on_window_left
    store.dispatch Actions::WindowLeft.new
  end

  def on_window_right
    store.dispatch Actions::WindowRight.new
  end

  def on_menu_up
    store.dispatch Actions::MenuUp.new
  end

  def on_menu_down
    store.dispatch Actions::MenuDown.new
  end

  def on_new_message_enter
    return if state[:data][:active_friend_index].nil?

    friend_number = state[:data][:friends].keys[state[:data][:active_friend_index]]

    return if friend_number.nil?

    text = state[:data][:friends][friend_number][:new_message][:text].strip.freeze

    return if text.empty?

    friend = @tox_client.friend friend_number
    error = false

    begin
      friend.send_message text
    rescue
      error = true
    end

    store.dispatch Actions::AddOutFriendMessage.new friend, text, error
  end

  def on_new_message_putc(char)
    store.dispatch Actions::NewMessagePutc.new char
  end

  def on_new_message_left
    store.dispatch Actions::NewMessageLeft.new
  end

  def on_new_message_right
    store.dispatch Actions::NewMessageRight.new
  end

  def on_new_message_home
    store.dispatch Actions::NewMessageHome.new
  end

  def on_new_message_end
    store.dispatch Actions::NewMessageEnd.new
  end

  def on_new_message_backspace
    store.dispatch Actions::NewMessageBackspace.new
  end

  def on_new_message_delete
    store.dispatch Actions::NewMessageDelete.new
  end
end
