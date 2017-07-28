# frozen_string_literal: true

require 'obredux'

require 'actions/load_friends'
require 'actions/add_friend'
require 'actions/add_friend_message'
require 'actions/change_friend_name'
require 'actions/change_friend_status'
require 'actions/change_friend_status_message'
require 'actions/new_message_enter'
require 'actions/new_message_putc'

module Actions
  class WindowLeft  < Obredux::Action; end
  class WindowRight < Obredux::Action; end

  class MenuUp   < Obredux::Action; end
  class MenuDown < Obredux::Action; end

  class NewMessageLeft      < Obredux::Action; end
  class NewMessageRight     < Obredux::Action; end
  class NewMessageHome      < Obredux::Action; end
  class NewMessageEnd       < Obredux::Action; end
  class NewMessageBackspace < Obredux::Action; end
  class NewMessageDelete    < Obredux::Action; end
end
