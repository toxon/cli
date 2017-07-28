# frozen_string_literal: true

module Obredux
  UNDEFINED = {}.freeze

  class Action; end

  class Init < Action; end

  class Store
    attr_reader :reducer_klass, :state

    def initialize(reducer_klass)
      @reducer_klass = reducer_klass
      @state = UNDEFINED
      dispatch Init.new
    end

    def dispatch(action)
      @state = reducer_klass.new(state, action).call
    end
  end

  class Reducer
    def self.combine(options = nil)
      @combine ||= {}

      return @combine if options.nil?

      options.each do |key, reducer_klass|
        @combine[key] = reducer_klass
      end
    end

    def initialize(state, action)
      @state = state
      @action = action
    end

    def call
      init = state.equal? UNDEFINED

      @state ||= {}.freeze

      unless self.class.combine.empty?
        @state = state.merge(
          self.class.combine.map do |key, reducer_klass|
            [
              key,
              reducer_klass.new(state[key], action).call,
            ]
          end.to_h.freeze,
        ).freeze
      end

      @state = state.merge initial_state if init

      reduce
    end

  private

    attr_reader :state, :action

    def initial_state
      {}.freeze
    end

    def reduce
      state
    end
  end
end
