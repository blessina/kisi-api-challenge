# frozen_string_literal: true

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    puts "worker begins"

    pubsub = Pubsub.new

    subscription = pubsub.subscription('default')

    subscriber = subscription.listen do |message|
      ActiveJob::Base.execute(JSON.parse(message.message.data))
      puts "Performing Message: #{message.message.data}, id: #{message.message_id}, published at #{message.message.published_at}"
      message.acknowledge!
    end

    subscriber.start

    subscriber.on_error do |exception|
      puts "Exception: #{exception.class} #{exception.message}"
      message.modify_ack_deadline! 300
    end

    puts "worker ends"

    sleep
  end
end
