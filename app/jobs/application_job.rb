class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered an error twice 5 minutes apart
  retry_on(StandardError, wait: 5.minutes, attempts: 2)
end
