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
    @list = List.new(
      0, 1,
      Curses.stdscr.maxx, Curses.stdscr.maxy - 1,
      1.upto(Curses.stdscr.maxy - 1 + 10).map do
        ['Qwe'].*(3 * (1 + rand(10))).join(' ')
      end
    )
  end

  def handle(event)
    case event
    when Curses::Key::UP
      @list.up
    when Curses::Key::DOWN
      @list.down
    end
  end

  def render
    Curses.clear

    Curses.attron Curses.color_pair 1
    Curses.setpos 0, 0
    Curses.addstr "items: #{@list.items.count}, height: #{@list.height}, active: #{@list.active}, top: #{@list.top}"

    @list.render

    Curses.refresh
  end
end

class List
  attr_reader :items, :height, :active, :top

  def initialize(x, y, width, height, items)
    @x = x
    @y = y
    @width = width
    @height = height
    @active = 0
    @top = 0
    @items = Array(items)
  end

  def render
    @items[@top...(@top + @height)].each_with_index.each do |item, offset|
      index = @top + offset

      if index == @active
        Curses.attron Curses.color_pair 2
      else
        Curses.attron Curses.color_pair 1
      end

      Curses.setpos @y + offset, @x
      Curses.addstr "#{index}: #{item}".ljust @width
    end
  end

  def up
    @active -= 1
    @active = @items.count - 1 if @active.negative?
    update
  end

  def down
    @active += 1
    @active = 0 if @active >= @items.count
    update
  end

  def update
    if @active < @top
      @top = @active
    elsif @active >= @top + @height
      @top = @active - @height + 1
    end
  end
end
