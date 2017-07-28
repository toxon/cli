# frozen_string_literal: true

module Actions
  class FriendRequest < Obredux::Action
    attr_reader :tox_client, :public_key

    def initialize(tox_client, public_key)
      self.tox_client = tox_client
      self.public_key = public_key
    end

  private

    def tox_client=(value)
      raise TypeError, "expected Tox client to be a #{Tox::Client}" unless value.is_a? Tox::Client
      @tox_client = value
    end

    def public_key=(value)
      raise TypeError, "expected public key to be a #{Tox::PublicKey}" unless value.is_a? Tox::PublicKey
      @public_key = value
    end
  end
end
