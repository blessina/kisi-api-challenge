# frozen_string_literal: true

class TimerJob < ApplicationJob
  queue_as :default

  def perform
    puts Time.now
    sleep(2.seconds)
  end
end