# frozen_string_literal: true

require('logger')

class ByeJob < ApplicationJob
  queue_as :default

  def perform
    sleep(5.seconds)
    Rails.logger.info("Bye!!")
  end
end