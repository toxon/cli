# frozen_string_literal: true

module Actions
  class FriendMessage < Obredux::Action
    attr_reader :friend, :text

    def initialize(friend, text)
      self.friend = friend
      self.text = text
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
  end
end
