# frozen_string_literal: true

module Widgets
  class Chat
    class Info
      attr_reader :x, :y, :width, :height
      attr_accessor :focused

      def initialize(x, y, width, height)
        @x = x
        @y = y

        @width  = width
        @height = height

        @focused = false
      end

      def trigger(event); end

      def render; end
    end
  end
end
