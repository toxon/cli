# frozen_string_literal: true

require 'thread'
require 'curses'

require 'faker'

require 'events'
require 'style'

# Basic
require 'widgets/base'
require 'widgets/text'

# Basic containers
require 'widgets/container'
require 'widgets/v_panel'

require 'widgets/main'

require 'widgets/menu'
require 'widgets/menu/logo'

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

  def window
    @window ||= Widgets::Main.new(
      0,
      0,
      Curses.stdscr.maxx,
      Curses.stdscr.maxy,
    )
  end

  def render
    window.render
    Curses.refresh
  end

  def handle(char)
    case char
    when "\t".ord
      window.trigger Events::Tab.new

    when Curses::Key::SLEFT
      window.trigger Events::Window::Left.new
    when Curses::Key::SRIGHT
      window.trigger Events::Window::Right.new

    when Curses::Key::UP
      window.trigger Events::Panel::Up.new
    when Curses::Key::DOWN
      window.trigger Events::Panel::Down.new

    when /[a-zA-Z0-9 ]/
      window.trigger Events::Text::Putc.new char
    when Curses::Key::LEFT
      window.trigger Events::Text::Left.new
    when Curses::Key::RIGHT
      window.trigger Events::Text::Right.new
    when Curses::Key::HOME
      window.trigger Events::Text::Home.new
    when Curses::Key::END
      window.trigger Events::Text::End.new
    when Curses::Key::BACKSPACE
      window.trigger Events::Text::Backspace.new
    when Curses::Key::DC
      window.trigger Events::Text::Delete.new
    end
  end
end
