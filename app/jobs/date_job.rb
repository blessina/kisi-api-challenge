# frozen_string_literal: true

class DateJob < ApplicationJob
  queue_as :default

  def perform
    sleep(3.seconds)
    puts Date.today
  end
end