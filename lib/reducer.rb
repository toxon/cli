# frozen_string_literal: true

module Reducer
  def self.call(state, action)
    case action
    when Actions::LoadFriends
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
    else
      state
    end
  end
end
