# frozen_string_literal: true

require 'react'
require 'react/curses'

# Additional classes
require 'events'
require 'style'

# Basic
require 'widgets/text'

# Basic containers
require 'widgets/container'
require 'widgets/v_panel'

require 'widgets/main'
require 'widgets/sidebar'
require 'widgets/logo'
require 'widgets/menu'

require 'widgets/chat'
require 'widgets/chat/info'
require 'widgets/chat/history'
require 'widgets/chat/new_message'

class Screen
  attr_writer :props

  def initialize
    Curses.init_screen
    Curses.start_color
    Curses.noecho # do no echo input
    Curses.curs_set 0 # invisible cursor
    Curses.timeout = 0 # non-blocking input
    Curses.stdscr.keypad = true
  end

  def close
    Curses.close_screen
  end

  def draw
    React::Curses.render render
  end

  def render
    React::Element.create :stdscr do
      React::Element.create :wrapper do
        React::Element.create Widgets::Main, @props
      end
    end
  end

  def poll
    loop do
      ch = Curses.getch
      break if ch.nil?
      event = create_event ch
      next if event.nil?
      elem = render
      React::Curses::Nodes.klass_for(elem).new(nil, elem).children[0].children[0].instance.trigger event
    end
  end

private

  def create_event(char)
    case char
    when Curses::Key::SLEFT
      Events::Window::Left.new
    when Curses::Key::SRIGHT
      Events::Window::Right.new

    when "\n".ord
      Events::Text::Enter.new

    when Curses::Key::LEFT
      Events::Text::Left.new
    when Curses::Key::RIGHT
      Events::Text::Right.new
    when Curses::Key::UP
      Events::Text::Up.new
    when Curses::Key::DOWN
      Events::Text::Down.new
    when Curses::Key::HOME
      Events::Text::Home.new
    when Curses::Key::END
      Events::Text::End.new
    when Curses::Key::BACKSPACE
      Events::Text::Backspace.new
    when Curses::Key::DC
      Events::Text::Delete.new

    when String
      Events::Text::Putc.new char
    end
  end
end
