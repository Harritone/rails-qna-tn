# frozen_string_literal: true

# QuestionUpdateNotificationService is responsible for sending question update notification mail to subscribers
class QuestionUpdateNotificationService
  def initialize(answer)
    @answer = answer
  end

  def call
    @answer.question.subscribers.find_each(batch_size: 500) do |user|
      QuestionUpdateMailer.send_notification(user, @answer).deliver_later
    end
  end
end
