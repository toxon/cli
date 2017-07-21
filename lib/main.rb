# frozen_string_literal: true

require 'thread'
require 'curses'

require 'widgets/search'
require 'widgets/list'

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

    Curses.init_pair 1, Curses::COLOR_WHITE, Curses::COLOR_BLACK
    Curses.init_pair 2, Curses::COLOR_BLACK, Curses::COLOR_WHITE
    Curses.init_pair 3, Curses::COLOR_BLUE,  Curses::COLOR_BLACK
    Curses.init_pair 4, Curses::COLOR_BLACK, Curses::COLOR_BLUE

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
    @search = Widgets::Search.new 0, 0, Curses.stdscr.maxx, 1

    @list = Widgets::List.new(
      0, 1,
      Curses.stdscr.maxx, Curses.stdscr.maxy - 1,
      1.upto(Curses.stdscr.maxy - 1 + 10).map do
        ['Qwe'].*(3 * (1 + rand(15))).join(' ')
      end
    )
  end

  def render
    Curses.clear

    @search.render
    @list.render

    Curses.refresh
  end

  def handle(event)
    case event
    when /[a-zA-Z0-9 _-]/
      @search.putc event
    when Curses::Key::LEFT
      @search.left
    when Curses::Key::RIGHT
      @search.right
    when Curses::Key::HOME
      @search.home
    when Curses::Key.const_get(:END)
      @search.end
    when Curses::Key::BACKSPACE
      @search.backspace
    when Curses::Key::DC
      @search.delete
    when Curses::Key::UP
      @list.up
    when Curses::Key::DOWN
      @list.down
    end
  end
end
