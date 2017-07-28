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
end
