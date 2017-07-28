# frozen_string_literal: true

module Actions
  class AddOutFriendMessage < Obredux::Action
    attr_reader :friend, :text, :error

    def initialize(friend, text, error)
      self.friend = friend
      self.text = text
      self.error = error
    end

  private

    def friend=(value)
      raise TypeError, "expected friend to be a #{Tox::Friend}" unless value.is_a? Tox::Friend
      @friend = value
    end

    def text=(value)
      raise TypeError, "expected text to be a #{String}" unless value.is_a? String
      @text = value.frozen? ? value : value.dup.freeze
    end

    def error=(value)
      @error = !!value
    end
  end
end
