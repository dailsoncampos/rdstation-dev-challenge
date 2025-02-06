class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    CartAbandonmentService.call
  end
end
