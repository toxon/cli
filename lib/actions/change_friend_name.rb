# frozen_string_literal: true

module Actions
  class ChangeFriendName < Obredux::Action
    attr_reader :friend, :new_name

    def initialize(friend, new_name)
      self.friend = friend
      self.new_name = new_name
    end

  private

    def friend=(value)
      raise TypeError, "expected friend to be a #{Tox::Friend}" unless value.is_a? Tox::Friend
      @friend = value
    end

    def new_name=(value)
      raise TypeError, "expected name to be a #{String}" unless value.is_a? String
      @new_name = value.frozen? ? value : value.dup.freeze
    end
  end
end
