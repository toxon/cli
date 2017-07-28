# frozen_string_literal: true

module Actions
  class NewMessagePutc < Obredux::Action
    attr_reader :char

    def initialize(char)
      self.char = char
    end

  private

    def char=(value)
      raise TypeError,    "expected char to be a #{String}" unless value.is_a? String
      raise ArguentError, 'expected char to have length 1'  unless value.length == 1
      @char = value.frozen? ? value : value.dup.freeze
    end
  end
end
