# frozen_string_literal: true

module Curses
  module React
    class Element
      KEY_REQUEST = :key

      private_class_method :new

      def self.create(type, props = {}, &block)
        props = props.dup
        props[:key] ||= yield_key_request
        yield_result new type, props, &block
      end

      def self.yield_key_request
        Fiber.yield KEY_REQUEST
      rescue FiberError
        0
      end

      def self.yield_result(result)
        Fiber.yield result
      rescue FiberError
        result
      end

      attr_reader :type, :props, :key

      def initialize(type, props = {})
        self.type  = type
        self.props = props

        if block_given?
          fiber = Fiber.new do
            yield
            nil
          end

          loop do
            data = fiber.resume
            data = fiber.resume children.size if data == KEY_REQUEST
            break if data.nil?
            add_child data
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

      def type=(value)
        return @type = value if value.is_a? Symbol

        raise TypeError,     "expected type to be a #{Class}"        unless value.is_a? Class
        raise ArgumentError, "expected type to inherit #{Component}" unless value < Component

        @type = value
      end

      def props=(value)
        raise TypeError, "expected props to be a #{Hash}" unless value.is_a? Hash

        self.key      = value.delete :key      if value.key? :key
        self.children = value.delete :children if value.key? :children

        @props = value.freeze
      end

      def key=(value)
        @key = value.freeze
      end

      def children=(value)
        value.each { |child| add_child child }
        children.freeze
      end
    end
  end
end
