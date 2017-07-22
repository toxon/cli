# frozen_string_literal: true

module Widgets
  class Container < Base
    attr_reader :focus

    def trigger(event)
      focus.trigger event
    end

    def draw
      children.each(&:render)
    end

    def children
      raise NotImplementedError, "#{self.class}#children"
    end

    def focus=(value)
      focus&.focused = false
      @focus = value
      focus.focused = true
    end

    def focused=(value)
      super
      focus.focused = focused
    end
  end
end
