# frozen_string_literal: true

module Obredux
  UNDEFINED = Object.new.freeze

  class Action; end

  class Init < Action; end

  class Store
    attr_reader :reducer, :state

    attr_writer :state

    def initialize(reducer)
      @reducer = reducer
      # @state = reducer.call UNDEFINED, Init.new
    end

    def dispatch(action)
      @state = reducer.call state, action
    end
  end
end
