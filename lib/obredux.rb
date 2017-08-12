# frozen_string_literal: true

module Obredux
  UNDEFINED = {}.freeze

  class Action; end

  class Init < Action; end

  class Middleware
    def initialize(store)
      self.store = store
    end

    def call(_action)
      raise NotImplementedError, "#{self.class}#call"
    end

  private

    def store=(value)
      raise TypeError, "expected #store to be a #{Store}" unless value.is_a? Store
      @store = value
    end
  end

  class Thunk < Middleware
    def call(action)
      return action unless action.is_a? Action
      action.call dispatch_method
    end

    def dispatch_method
      store.public_method :dispatch
    end

    class Action < Action
      def call(dispatch)
        raise NotImplementedError, "#{self.class}#call"
      end
    end
  end

  class Store
    attr_reader :reducer_klass, :state, :middleware

    def initialize(reducer_klass, middleware = [])
      self.reducer_klass = reducer_klass
      self.state = UNDEFINED
      self.middleware = middleware

      dispatch Init.new
    end

    def dispatch(action)
      raise TypeError, "expected action to be an #{Action}" unless action.is_a? Action

      action = middleware.inject(action) do |old_action, fn|
        new_action = fn.call old_action
        break if new_action.nil?
        new_action
      end

      return if action.nil?

      self.state = reducer_klass.new(state, action).call
    end

  private

    def reducer_klass=(value)
      raise TypeError, "expected #reducer_klass to be a #{Class}"      unless value.is_a? Class
      raise TypeError, "expected #reducer_klass to inherit #{Reducer}" unless value < Reducer
      @reducer_klass = value
    end

    def state=(value)
      raise TypeError, "expected #state to be a #{Hash}" unless value.is_a? Hash
      raise TypeError, 'expected #state to be frozen'    unless value.frozen?
      @state = value
    end

    def middleware=(value)
      @middleware = value.map do |middleware_klass|
        unless middleware_klass.is_a?(Class) && middleware_klass < Middleware
          raise TypeError, "expected #middleware to be an array of #{Middleware} classes"
        end
        middleware_klass.new self
      end.freeze
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

      @state = state.merge(initial_state).freeze if init

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
