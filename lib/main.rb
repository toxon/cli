# frozen_string_literal: true

require 'thread'

require 'faker'

require 'screen'

class Main
  def self.inherited(_base)
    raise "#{self} is final"
  end

  def self.mutex
    (@mutex ||= Mutex.new).tap { freeze }
  end

  def initialize
    raise "#{self.class} is singleton" unless self.class.mutex.try_lock
    call
  end

private

  def call
    before_loop
    loop do
      before_iteration
      sleep
      after_iteration
    end
    after_loop
  end

  def sleep
    super 0.01
  end

  def before_loop
    @screen = Screen.new
    Style.default = Style.new
  end

  def after_loop
    @screen.close
  end

  def before_iteration
    @screen.render
  end

  def after_iteration
    @screen.poll
  end
end
