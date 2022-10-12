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
      message_data = JSON.parse(message.message.data)

      Rails.logger.info("Performing Message id: #{message.message_id}, published at: #{message.message.published_at} message data:#{message.message.data}")
      Rails.logger.info("Performing job id #{message_data['job_id']}")

      ActiveJob::Base.execute(message_data)
      message.acknowledge!
    end

    subscriber.on_error do |exception|
      Rails.logger.info("Exception: #{exception.class} #{exception.message}")
      message.modify_ack_deadline! 0
    end

    at_exit do
      subscriber.stop!(10)
    end

    subscriber.start

    Rails.logger.info("worker ends")

    sleep
  end
end
