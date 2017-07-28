# frozen_string_literal: true

module Actions
  class NewMessageEnter < Obredux::Action
    attr_reader :tox_client

    def initialize(tox_client)
      self.tox_client = tox_client
    end

  private

    def tox_client=(value)
      raise TypeError, "expected Tox client to be a #{Tox::Client}" unless value.is_a? Tox::Client
      @tox_client = value
    end
  end
end
