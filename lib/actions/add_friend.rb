# frozen_string_literal: true

module Actions
  class AddFriend < Obredux::Action
    attr_reader :friend

    def initialize(friend)
      self.friend = friend
    end

  private

    def friend=(value)
      raise TypeError, "expected friend to be a #{Tox::Friend}" unless value.is_a? Tox::Friend
      @friend = value
    end
  end
end
