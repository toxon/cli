# frozen_string_literal: true

module Curses
  module React
    class Element
      def self.create(type, props = {}, &block)
        element = new type, props, &block

        begin
          Fiber.yield element
        rescue FiberError
          element
        end
      end

      attr_reader :type, :props

      def initialize(type, props = {})
        self.type  = type
        self.props = props

        if block_given?
          fiber = Fiber.new do
            yield
            nil
          end

          loop do
            child = fiber.resume
            break if child.nil?
            add_child child
          end
        end

        children.freeze
      end

    private

      def children
        @children ||= []
      end

      def add_child(child)
        raise TypeError, "expected child to be an #{Element}" unless child.is_a? Element
        children << child
      end

      def children=(value)
        value.each { |child| add_child child }
        children.freeze
      end

      def type=(value)
        return @type = value if value.is_a? Symbol

        raise TypeError,     "expected type to be a #{Class}"        unless value.is_a? Class
        raise ArgumentError, "expected type to inherit #{Component}" unless value < Component
        @type = value
      end

      def props=(value)
        raise TypeError, "expected props to be a #{Hash}" unless value.is_a? Hash

        value = value.dup
        self.children = value.delete :children if value.key? :children

        @props = value.freeze
      end
    end
  end
end
