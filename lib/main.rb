# frozen_string_literal: true

require 'thread'
require 'curses'

require 'widgets/menu'
require 'widgets/peers'
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
    Curses.init_pair 5, Curses::COLOR_BLACK, Curses::COLOR_CYAN

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
    menu_width  = Curses.stdscr.maxx / 5
    peers_width = Curses.stdscr.maxx / 4

    @menu = Widgets::Menu.new 0, 0, menu_width, Curses.stdscr.maxy

    @peers = Widgets::Peers.new menu_width, 0, peers_width, Curses.stdscr.maxy
  end

  def render
    Curses.clear

    @menu.render
    @peers.render

    Curses.refresh
  end

  def handle(event)
    case event
    when /[a-zA-Z0-9 _-]/
      @peers.putc event
    when Curses::Key::LEFT
      @peers.left
    when Curses::Key::RIGHT
      @peers.right
    when Curses::Key::HOME
      @peers.home
    when Curses::Key::END
      @peers.endk
    when Curses::Key::BACKSPACE
      @peers.backspace
    when Curses::Key::DC
      @peers.delete
    when Curses::Key::UP
      @peers.up
    when Curses::Key::DOWN
      @peers.down
    end
  end
end
