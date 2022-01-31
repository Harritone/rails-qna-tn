class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :content, presence: true, length: { minimum: 5, maximum: 10_000 }

  after_create_commit { CommentsBroadcastJob.perform_later(self) }
end
