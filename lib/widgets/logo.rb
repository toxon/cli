# frozen_string_literal: true

module Widgets
  class Logo < React::Component
    TMP_LOGO = [
      '  _____ ___ _  _ ___  _   _  ',
      ' |_   _/ _ \ \/ / _ \| \ | | ',
      '   | || | | \  / | | |  \| | ',
      '   | || |_| /  \ |_| | |\  | ',
      '   |_| \___/_/\_\___/|_| \_| ',
      '                             ',
      '        Version 0.0.0        ',
      "          API #{Tox::Version::API_VERSION}",
      "          ABI #{Tox::Version.abi_version}",
      '                             ',
    ].freeze

    WIDTH  = TMP_LOGO.first.length
    HEIGHT = TMP_LOGO.length

    LOGO = TMP_LOGO.map { |s| s.ljust WIDTH }.freeze

    def render
      create_element :window, x: props[:x], y: props[:y], width: props[:width], height: props[:height] do
        create_element :lines do
          LOGO.each_with_index do |s|
            create_element :line do
              create_element :text, text: s, attr: Style.default.logo_attr
            end
          end
        end
      end
    end
  end
end
