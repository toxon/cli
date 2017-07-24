# frozen_string_literal: true

module Widgets
  class Main < Container
    def initialize(parent, x, y, width, height)
      super

      @sidebar = Widgets::Sidebar.new self, x,                  y, nil,                    height
      @chat    = Widgets::Chat.new    self, x + @sidebar.width, y, width - @sidebar.width, height
    end

    def focus
      case props[:focus]
      when :sidebar then @sidebar
      when :chat    then @chat
      end
    end

    def props=(_value)
      super
      @sidebar.props = props[:sidebar]
      @chat.props    = props[:chat]
    end

    def children
      [@sidebar, @chat]
    end

    def trigger(event)
      case event
      when Events::Window::Left
        self.focus = @sidebar
      when Events::Window::Right
        self.focus = @chat
      else
        focus.trigger event
      end
    end
  end
end
