# frozen_string_literal: true

module Actions
  class ChangeFriendStatusMessage < Obredux::Action
    attr_reader :friend, :new_status_message

    def initialize(friend, new_status_message)
      self.friend = friend
      self.new_status_message = new_status_message
    end

  private

    def friend=(value)
      raise TypeError, "expected friend to be a #{Tox::Friend}" unless value.is_a? Tox::Friend
      @friend = value
    end

    def new_status_message=(value)
      raise TypeError, "expected status message to be a #{String}" unless value.is_a? String
      @new_status_message = value.frozen? ? value : value.dup.freeze
    end
  end
end
