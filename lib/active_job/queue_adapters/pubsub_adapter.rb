require("google/cloud/pubsub")
require("concurrent/scheduled_task")
require('logger')
require('json')

module ActiveJob
  module QueueAdapters
    class PubsubAdapter
      # Enqueue a job to be performed.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      def enqueue(job, params={})
        serialized_job = job.serialize
        serialized_job.merge(params)
        topic = pubsub.topic(job.queue_name)
        msg = topic.publish(JSON.dump(serialized_job), params)
        job.provider_job_id = msg.message_id
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        enqueue(job, timestamp: timestamp)
      end

      private

      def pubsub
        @client = Pubsub.new
      end
    end
  end
end