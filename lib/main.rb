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
    @items = 1.upto(Curses.stdscr.maxy + 10).map do
      ['Qwe'].*(3 * (1 + rand(10))).join(' ')
    end

    @top = 0
    @active = 0
  end

  def handle(event)
    case event
    when Curses::Key::UP
      @active -= 1
      @active = @items.count - 1 if @active.negative?
    when Curses::Key::DOWN
      @active += 1
      @active = 0 if @active >= @items.count
    end
  end

  def render
    Curses.clear

    @items.each_with_index.to_a[@top...(@top + Curses.stdscr.maxy)].each do |item, index|
      if index == @active
        Curses.attron Curses.color_pair 2
      else
        Curses.attron Curses.color_pair 1
      end

      Curses.setpos index, 0
      Curses.addstr "#{index}: #{item}".ljust Curses.stdscr.maxx
    end

    Curses.refresh
  end
end
