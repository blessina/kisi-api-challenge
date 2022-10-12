require("google/cloud/pubsub")
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
        msg = topic(job.queue_name).publish(JSON.dump(serialized_job), params)
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
        @client ||= Pubsub.new
      end

      def topic(queue_name)
        @topic = pubsub.topic(queue_name)
      end
    end
  end
end