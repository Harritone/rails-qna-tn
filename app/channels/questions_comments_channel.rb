class QuestionsCommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions_#{params['question_id']}_channel"
  end

  def unsubscribed
  end

  def send_comment(data)
    current_user.comments.create!(content: data['comment'], commentable_id: data['question_id'], commentable_type: 'Question')
  end
end
