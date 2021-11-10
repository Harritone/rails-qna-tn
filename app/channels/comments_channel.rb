class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments/question_#{params['question_id']}_channel"
  end
end
