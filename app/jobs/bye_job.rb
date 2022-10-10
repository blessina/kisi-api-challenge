# frozen_string_literal: true

class ByeJob < ApplicationJob
  queue_as :default

  def perform
    sleep(5.seconds)
    puts "Bye!!"
  end
end