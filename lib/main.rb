# frozen_string_literal: true

require 'thread'

require 'faker'

require 'screen'

class Main
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
    before_loop
    loop do
      before_iteration
      sleep
      after_iteration
    end
    after_loop
  end

  def sleep
    super 0.01
  end

  def before_loop
    @screen = Screen.new
    Style.default = Style.new
  end

  def after_loop
    @screen.close
  end

  def before_iteration
    @screen.props = state
    @screen.render
  end

  def after_iteration
    @screen.poll
  end

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

      on_new_message_putc: method(:on_new_message_putc),

      on_new_message_left:  method(:on_new_message_left),
      on_new_message_right: method(:on_new_message_right),
      on_new_message_home:  method(:on_new_message_home),
      on_new_message_end:   method(:on_new_message_end),

      on_new_message_backspace: method(:on_new_message_backspace),
      on_new_message_delete:    method(:on_new_message_delete),

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
          items: 1.upto(Curses.stdscr.maxy).map do
            {
              name: Faker::Name.name,
              online: [false, true].sample,
            }
          end,
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

          name: Faker::Name.name,
          public_key: SecureRandom.hex(32),
        }.freeze,

        new_message: {
          x: Widgets::Logo::WIDTH,
          y: Curses.stdscr.maxy - 1,
          width: Curses.stdscr.maxx - Widgets::Logo::WIDTH,
          height: 1,
          focused: false,

          text: '',
          cursor_pos: 0,
        }.freeze,

        history: {
          x: Widgets::Logo::WIDTH,
          y: 2,
          width: Curses.stdscr.maxx - Widgets::Logo::WIDTH,
          height: Curses.stdscr.maxy - 3,
          focused: true,

          messages: 1.upto(100).map do
            {
              out: rand <= 0.2,
              time: Faker::Time.forward,
              name: Faker::Name.name,
              text: Faker::Lorem.sentence,
            }
          end,
        }.freeze,
      }.freeze,
    }.freeze
  end

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
    @state = state.merge(
      sidebar: state[:sidebar].merge(
        menu: self.class.update_menu(
          state[:sidebar][:menu],
          active: state[:sidebar][:menu][:active] - 1,
        ),
      ).freeze,
    ).freeze
  end

  def on_menu_down
    @state = state.merge(
      sidebar: state[:sidebar].merge(
        menu: self.class.update_menu(
          state[:sidebar][:menu],
          active: state[:sidebar][:menu][:active] + 1,
        ),
      ).freeze,
    ).freeze
  end

  def on_new_message_putc(char)
    text       = state[:chat][:new_message][:text]
    cursor_pos = state[:chat][:new_message][:cursor_pos]

    @state = state.merge(
      chat: state[:chat].merge(
        new_message: self.class.update_new_message(
          state[:chat][:new_message],
          text: "#{text[0...cursor_pos]}#{char}#{text[cursor_pos..-1]}",
          cursor_pos: cursor_pos + 1,
        ),
      ).freeze,
    ).freeze
  end

  def on_new_message_left
    @state = state.merge(
      chat: state[:chat].merge(
        new_message: self.class.update_new_message(
          state[:chat][:new_message],
          text:       state[:chat][:new_message][:text],
          cursor_pos: state[:chat][:new_message][:cursor_pos] - 1,
        ),
      ).freeze,
    ).freeze
  end

  def on_new_message_right
    @state = state.merge(
      chat: state[:chat].merge(
        new_message: self.class.update_new_message(
          state[:chat][:new_message],
          text:       state[:chat][:new_message][:text],
          cursor_pos: state[:chat][:new_message][:cursor_pos] + 1,
        ),
      ).freeze,
    ).freeze
  end

  def on_new_message_home
    @state = state.merge(
      chat: state[:chat].merge(
        new_message: self.class.update_new_message(
          state[:chat][:new_message],
          text:       state[:chat][:new_message][:text],
          cursor_pos: 0,
        ),
      ).freeze,
    ).freeze
  end

  def on_new_message_end
    @state = state.merge(
      chat: state[:chat].merge(
        new_message: self.class.update_new_message(
          state[:chat][:new_message],
          text:       state[:chat][:new_message][:text],
          cursor_pos: state[:chat][:new_message][:text].length,
        ),
      ).freeze,
    ).freeze
  end

  def on_new_message_backspace
    text       = state[:chat][:new_message][:text]
    cursor_pos = state[:chat][:new_message][:cursor_pos]

    return unless cursor_pos.positive?

    @state = state.merge(
      chat: state[:chat].merge(
        new_message: self.class.update_new_message(
          state[:chat][:new_message],
          text: "#{text[0...(cursor_pos - 1)]}#{text[cursor_pos..-1]}",
          cursor_pos: cursor_pos - 1,
        ),
      ).freeze,
    ).freeze
  end

  def on_new_message_delete
    text       = state[:chat][:new_message][:text]
    cursor_pos = state[:chat][:new_message][:cursor_pos]

    return if cursor_pos > text.length

    @state = state.merge(
      chat: state[:chat].merge(
        new_message: self.class.update_new_message(
          state[:chat][:new_message],
          text: "#{text[0...cursor_pos]}#{text[(cursor_pos + 1)..-1]}",
          cursor_pos: cursor_pos,
        ),
      ).freeze,
    ).freeze
  end

  class << self
    def update_menu(state, active:)
      top = state[:top]

      if active.negative?
        active = state[:items].count - 1
      elsif active >= state[:items].count
        active = 0
      end

      if active < state[:top]
        top = active
      elsif active >= state[:top] + state[:height]
        top = active - state[:height] + 1
      end

      state.merge(
        active: active,
        top: top,
      ).freeze
    end

    def update_new_message(state, text:, cursor_pos:)
      if cursor_pos.negative?
        cursor_pos = 0
      elsif cursor_pos > text.length
        cursor_pos = text.length
      end

      state.merge(
        text: text,
        cursor_pos: cursor_pos,
      ).freeze
    end
  end
end
