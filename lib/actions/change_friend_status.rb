# frozen_string_literal: true

module Actions
  class ChangeFriendStatus < Obredux::Action
    attr_reader :friend, :new_status

    def initialize(friend, new_status)
      self.friend = friend
      self.new_status = new_status
    end

  private

    def friend=(value)
      raise TypeError, "expected friend to be a #{Tox::Friend}" unless value.is_a? Tox::Friend
      @friend = value
    end

    def new_status=(value)
      raise TypeError, "expected status to be a #{Symbol}" unless value.is_a? Symbol
      @new_status = value.frozen? ? value : value.dup.freeze
    end
  end
end
