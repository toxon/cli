# frozen_string_literal: true

module Actions
  class LoadFriends < Obredux::Action
    attr_reader :friends

    def initialize(friends)
      self.friends = friends
    end

  private

    def friends=(value)
      @friends = value.map do |friend|
        raise TypeError, "expected friend to be a #{Tox::Friend}" unless friend.is_a? Tox::Friend
        friend
      end.freeze
    end
  end
end
