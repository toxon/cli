# frozen_string_literal: true

require 'thread'

require 'faker'

require 'screen'

class Main
  INITIAL_STATE = {
    focus: :sidebar,
    sidebar: {
      focus: :menu,
      menu: {
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
      focus: :new_message,
      info: {
        name: Faker::Name.name,
        public_key: SecureRandom.hex(32),
      }.freeze,
      new_message: {
        text: '',
        cursor_pos: 0,
      }.freeze,
      history: {
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
    @screen.props = INITIAL_STATE
    @screen.render
  end

  def after_iteration
    @screen.poll
  end
end
