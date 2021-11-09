class AnswersCommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "answers_#{params['answer_id']}_channel"
  end

  def unsubscribed
  end

  def send_comment(data)
    current_user.comments.create!(content: data['comment'], commentable_id: data['answer_id'], commentable_type: 'Answer')
  end
end

