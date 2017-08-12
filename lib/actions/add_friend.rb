# frozen_string_literal: true

module Actions
  class AddFriend < Obredux::Thunk::Action
    attr_reader :tox_client, :public_key, :text

    def initialize(tox_client, public_key, text)
      self.tox_client = tox_client
      self.public_key = public_key
      self.text       = text
    end

    def call(dispatch)
      dispatch.call Done.new tox_client.friend_add_norequest public_key
    end

  private

    def tox_client=(value)
      raise TypeError, "expected #tox_client to be a #{Tox::Client}" unless value.is_a? Tox::Client
      @tox_client = value
    end

    def public_key=(value)
      raise TypeError, "expected #public_key to be a #{Tox::PublicKey}" unless value.is_a? Tox::PublicKey
      @public_key = value
    end

    def text=(value)
      raise TypeError, "expected #text to be a #{String}" unless value.is_a? String
      @text = value
    end

    class Done < Obredux::Action
      attr_reader :friend

      def initialize(friend)
        self.friend = friend
      end

    private

      def friend=(value)
        raise TypeError, "expected #friend to be a #{Tox::Friend}" unless value.is_a? Tox::Friend
        @friend = value
      end
    end
  end
end
