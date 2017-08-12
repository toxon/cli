# frozen_string_literal: true

require 'obredux'

module Obredux
  class Thunk < Middleware
    def call(store, action)
      return action unless action.is_a? Action
      action.call store.public_method :dispatch
    end

    class Action < Action
      def call(_dispatch)
        raise NotImplementedError, "#{self.class}#call"
      end
    end
  end
end
