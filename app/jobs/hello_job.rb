# frozen_string_literal: true

class HelloJob < ApplicationJob
  queue_as :default

  def perform
    sleep(4.seconds)
    puts "Hello!!!"
  end
end