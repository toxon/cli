# frozen_string_literal: true

module Widgets
  class Peers
    def initialize(x, y, width, height)
      @search = Widgets::Search.new x, y,     width, 1
      @list   = Widgets::List.new   x, y + 1, width, height - 1
    end

    def render
      @search.render
      @list.render
    end

    def putc(event)
      @search.putc event
    end

    def left
      @search.left
    end

    def right
      @search.right
    end

    def home
      @search.home
    end

    def endk
      @search.endk
    end

    def backspace
      @search.backspace
    end

    def delete
      @search.delete
    end

    def up
      @list.up
    end

    def down
      @list.down
    end
  end
end
