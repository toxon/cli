# frozen_string_literal: true

module Obredux
  UNDEFINED = Object.new.freeze

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
    def initialize(state, action)
      @state = state
      @action = action
    end

    def call
      @state = initial_state if state.equal? UNDEFINED
      @state ||= {}.freeze
      reduce
    end

  private

    attr_reader :state, :action

    def initial_state
      raise NotImplementedError, "#{self.class}#initial_state"
    end

    def reduce
      raise NotImplementedError, "#{self.class}#reduce"
    end
  end
end
