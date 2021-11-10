class CommentsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
    # if comment.commentable_type == 'Answer'
    ActionCable.server.broadcast "comments/question_#{question_id(comment)}_channel", element: render_comment(comment), comment: comment
    # else
      # ActionCable.server.broadcast "questions_#{comment.commentable.id}_channel", comment: render_comment(comment)
    # end
  end

  private

  def question_id(comment)
    comment.commentable.is_a?(Question) ? comment.commentable.id : comment.commentable.question.id
  end

  def render_comment(comment)
    ApplicationController.render partial: 'comments/comment', locals: { comment: comment }
  end
end
