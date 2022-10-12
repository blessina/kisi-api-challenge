# frozen_string_literal: true

require('logger')

class TimerJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info(Time.now)
    sleep(2.seconds)
  end
end