# frozen_string_literal: true

require('logger')

class DateJob < ApplicationJob
  queue_as :default

  def perform
    sleep(3.seconds)
    Rails.logger.info(Date.today)
  end
end