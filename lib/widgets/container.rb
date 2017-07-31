# frozen_string_literal: true

module Widgets
  class Container < React::Component
  private

    def focus
      raise NotImplementedError, "#{self.class}#focus"
    end
  end
end
