# frozen_string_literal: true

# QuestionUpdateNotificationJob is responsible for performing email notification if question has new answers
class QuestionUpdateNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    QuestionUpdateNotificationService.new(answer).call
  end
end
