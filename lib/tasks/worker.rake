# frozen_string_literal: true

require('logger')

namespace(:worker) do
  desc("Run the worker")
  task(:run, [:queue] => [:environment]) do |task, args|
    Rails.logger.info("worker begins")

    pubsub = Pubsub.new

    Rails.logger.info("Performing jobs in #{args[:queue]} queue")

    subscription = pubsub.subscription(args[:queue])

    subscriber = subscription.listen do |message|
      ActiveJob::Base.execute(JSON.parse(message.message.data))
      Rails.logger.info("Performing Message: #{message.message.data}, id: #{message.message_id}, published at #{message.message.published_at}")
      message.acknowledge!
    end

    subscriber.start

    subscriber.on_error do |exception|
      Rails.logger.info("Exception: #{exception.class} #{exception.message}")
      message.modify_ack_deadline! 300
    end

    Rails.logger.info("worker ends")

    sleep
  end
end
