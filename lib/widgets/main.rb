# frozen_string_literal: true

module Widgets
  class Main < Container
    def initialize(_parent)
      super

      @sidebar = Widgets::Sidebar.new self
      @chat    = Widgets::Chat.new    self
    end

    def props=(_value)
      super
      @sidebar.props = props[:sidebar]
      @chat.props    = props[:chat]
    end

  private

    def focus
      case props[:focus]
      when :sidebar then @sidebar
      when :chat    then @chat
      end
    end

    def children
      [@sidebar, @chat]
    end
  end
end
