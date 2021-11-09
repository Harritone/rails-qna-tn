class CommentsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
    if comment.commentable_type == 'Answer'
      ActionCable.server.broadcast "answers_#{comment.commentable.id}_channel", comment: render_comment(comment)
    else
      ActionCable.server.broadcast "questions_#{comment.commentable.id}_channel", comment: render_comment(comment)
    end
  end

  private

  def render_comment(comment)
    ApplicationController.render partial: 'comments/comment', locals: { comment: comment }
  end
end
