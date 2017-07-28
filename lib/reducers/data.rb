# frozen_string_literal: true

module Reducers
  class Data < Obredux::Reducer
  private

    def initial_state
      {
        active_friend_index: nil,
        friends: {}.freeze,
      }.freeze
    end

    def reduce
      case action
      when Actions::LoadFriends
        load_friends
      when Actions::AddFriend
        add_friend
      when Actions::AddFriendMessage
        add_friend_message
      else
        state
      end
    end

    def load_friends
      state.merge(
        active_friend_index: action.friends.empty? ? nil : 0,

        friends: action.friends.map do |friend|
          [
            friend.number,
            public_key:     friend.public_key.to_hex.freeze,
            name:           friend.name.freeze,
            status:         friend.status,
            status_message: friend.status_message.freeze,
            history:        [].freeze,
            new_message: {
              text: '',
              cursor_pos: 0,
            }.freeze,
          ]
        end.to_h.freeze,
      ).freeze
    end

    def add_friend
      state.merge(
        active_friend_index: state[:active_friend_index] || state[:friends].count,

        friends: state[:friends].merge(
          action.friend.number => {
            public_key:     action.friend.public_key.to_hex.freeze,
            name:           action.friend.name.freeze,
            status:         action.friend.status,
            status_message: action.friend.status_message.freeze,
            history:        [].freeze,
            new_message: {
              text: '',
              cursor_pos: 0,
            }.freeze,
          }.freeze,
        ).freeze,
      ).freeze
    end

    def add_friend_message
      state.merge(
        friends: state[:friends].merge(
          action.friend.number => state[:friends][action.friend.number].merge(
            history: (state[:friends][action.friend.number][:history] + [
              out:  false,
              time: Time.now.utc.freeze,
              name: action.friend.name.freeze,
              text: action.text.freeze,
            ]).freeze,
          ).freeze,
        ).freeze,
      ).freeze
    end
  end
end
