# frozen_string_literal: true

require('logger')

class HelloJob < ApplicationJob
  queue_as :default

  def perform
    sleep(4.seconds)
    Rails.logger.info("Hello!!!")
  end
end