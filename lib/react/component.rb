# frozen_string_literal: true

module React
  class Component
    def initialize
      self.props = {}.freeze
    end

    def props=(value)
      raise TypeError,     "expected props to be a #{Hash}" unless value.is_a? Hash
      raise ArgumentError, 'expected props to be frozen'    unless value.frozen?
      @props = value
    end

    def trigger(event); end

  private

    attr_reader :props

    def create_element(type, props = {}, &block)
      Element.create type, props, &block
    end
  end
end
