# frozen_string_literal: true

require 'thread'
require 'curses'

require 'faker'

require 'events'
require 'style'

# Basic
require 'widgets/base'
require 'widgets/text'
require 'widgets/v_panel'

require 'widgets/messenger'

require 'widgets/menu'

require 'widgets/peers'
require 'widgets/peers/list'
require 'widgets/peers/search'

require 'widgets/chat'
require 'widgets/chat/info'
require 'widgets/chat/history'
require 'widgets/chat/new_message'

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
    Curses.init_screen
    Curses.start_color
    Curses.noecho # do no echo input
    Curses.curs_set 0 # invisible cursor
    Curses.timeout = 0 # non-blocking input
    Curses.stdscr.keypad = true

    Style.default = Style.new

    initials
  end

  def after_loop
    Curses.close_screen
  end

  def before_iteration
    render
  end

  def after_iteration
    loop do
      event = Curses.getch
      break if event.nil?
      handle event
    end
  end

  def initials
    @menu      = Widgets::Menu.new      0,           0, nil,                              Curses.stdscr.maxy
    @messenger = Widgets::Messenger.new @menu.width, 0, Curses.stdscr.maxx - @menu.width, Curses.stdscr.maxy

    @messenger.focused = true
  end

  def render
    @menu.render
    @messenger.render

    Curses.refresh
  end

  def handle(char)
    case char
    when Curses::Key::SLEFT
      @messenger.trigger Events::Window::Left.new
    when Curses::Key::SRIGHT
      @messenger.trigger Events::Window::Right.new

    when Curses::Key::UP
      @messenger.trigger Events::Panel::Up.new
    when Curses::Key::DOWN
      @messenger.trigger Events::Panel::Down.new

    when /[a-zA-Z0-9 ]/
      @messenger.trigger Events::Text::Putc.new char
    when Curses::Key::LEFT
      @messenger.trigger Events::Text::Left.new
    when Curses::Key::RIGHT
      @messenger.trigger Events::Text::Right.new
    when Curses::Key::HOME
      @messenger.trigger Events::Text::Home.new
    when Curses::Key::END
      @messenger.trigger Events::Text::End.new
    when Curses::Key::BACKSPACE
      @messenger.trigger Events::Text::Backspace.new
    when Curses::Key::DC
      @messenger.trigger Events::Text::Delete.new
    end
  end
end
