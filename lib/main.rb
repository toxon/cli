# frozen_string_literal: true

require 'thread'
require 'curses'

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
  end

  def after_loop
    Curses.close_screen
  end

  def before_iteration; end

  def after_iteration
    loop do
      event = Curses.getch
      break if event.nil?
      handle event
    end
  end

  def handle(event); end
end
