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
      when Actions::AddFriend::Done
        add_friend
      when Actions::AddFriendMessage
        add_friend_message
      when Actions::ChangeFriendName
        change_friend_name
      when Actions::ChangeFriendStatusMessage
        change_friend_status_message
      when Actions::ChangeFriendStatus
        change_friend_status
      when Actions::AddOutFriendMessage
        add_out_friend_message
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
            public_key:     friend.public_key.to_s,
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
            public_key:     action.friend.public_key.to_s,
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

    def change_friend_name
      state.merge(
        friends: state[:friends].merge(
          action.friend.number => state[:friends][action.friend.number].merge(
            name: action.new_name.freeze,
          ).freeze,
        ).freeze,
      ).freeze
    end

    def change_friend_status_message
      state.merge(
        friends: state[:friends].merge(
          action.friend.number => state[:friends][action.friend.number].merge(
            status_message: action.new_status_message.freeze,
          ).freeze,
        ).freeze,
      ).freeze
    end

    def change_friend_status
      state.merge(
        friends: state[:friends].merge(
          action.friend.number => state[:friends][action.friend.number].merge(
            status: action.new_status,
          ).freeze,
        ).freeze,
      ).freeze
    end

    def add_out_friend_message
      state.merge(
        friends: state[:friends].merge(
          action.friend.number => state[:friends][action.friend.number].merge(
            new_message: state[:friends][action.friend.number][:new_message].merge(
              text: '',
              cursor_pos: 0,
            ),

            history: (state[:friends][action.friend.number][:history] + [
              error:    action.error,
              out:      true,
              received: false,
              time:     Time.now.utc.freeze,
              name:     action.friend.client.name.freeze,
              text:     action.text,
            ]).freeze,
          ).freeze,
        ).freeze,
      ).freeze
    end
  end
end
