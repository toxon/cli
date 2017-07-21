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
    @search = Search.new 1, 1, Curses.stdscr.maxx - 2, 1

    @list = List.new(
      1, 2,
      Curses.stdscr.maxx - 2, Curses.stdscr.maxy - 3,
      1.upto(Curses.stdscr.maxy - 1 + 10).map do
        ['Qwe'].*(3 * (1 + rand(15))).join(' ')
      end
    )
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
    when Curses::Key::UP
      @list.up
    when Curses::Key::DOWN
      @list.down
    end
  end

  def render
    Curses.clear

    @search.render
    @list.render

    Curses.refresh
  end
end

class Search
  attr_reader :x, :y, :width, :height, :text, :cursor_pos

  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
    @text = ''
    @cursor_pos = 0
  end

  def render
    Curses.setpos x, y

    before_cursor = text[0...cursor_pos]
    under_cursor  = text[cursor_pos] || ' '
    after_cursor  = text[(1 + cursor_pos)..-1] || ''

    Curses.attron Curses.color_pair 3
    Curses.addstr before_cursor

    Curses.attron Curses.color_pair 4
    Curses.addstr under_cursor

    Curses.attron Curses.color_pair 3
    Curses.addstr after_cursor
  end

  def putc(c)
    @text += c
    @cursor_pos += 1
    update
  end

  def left
    @cursor_pos -= 1
    update
  end

  def right
    @cursor_pos += 1
    update
  end

  def home
    @cursor_pos = 0
  end

  def end
    @cursor_pos = @text.length
  end

  def backspace
    @text = text[0...-1]
    @cursor_pos -= 1
    update
  end

  def update
    if @cursor_pos.negative?
      @cursor_pos = 0
    elsif @cursor_pos > @text.length
      @cursor_pos = @text.length
    end
  end
end

class List
  attr_reader :x, :y, :width, :height, :active, :top, :items

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
    items[top...(top + height)].each_with_index.each do |item, offset|
      index = top + offset

      if index == active
        Curses.attron Curses.color_pair 2
      else
        Curses.attron Curses.color_pair 1
      end

      Curses.setpos y + offset, x

      s = "#{index}: #{item}"
      if s.length <= width
        Curses.addstr s.ljust width
      else
        Curses.addstr "#{s[0...width - 3]}..."
      end
    end
  end

  def up
    @active -= 1
    @active = items.count - 1 if active.negative?
    update
  end

  def down
    @active += 1
    @active = 0 if active >= items.count
    update
  end

  def update
    if active < top
      @top = active
    elsif active >= top + height
      @top = active - height + 1
    end
  end
end
