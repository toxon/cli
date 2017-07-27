# frozen_string_literal: true

module Helpers
  refine String do
    def etc(max_length, etc: '...')
      return self if length <= max_length
      return '' unless max_length.positive?
      orig_length = max_length - etc.length
      return etc[0...max_length] if orig_length <= 0
      "#{self[0...orig_length]}#{etc}"
    end

    def ljustetc(required_length, padstr: ' ', etc: '...')
      ljust(required_length, padstr).etc(required_length, etc: etc)
    end
  end
end
