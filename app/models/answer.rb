class Answer < ApplicationRecord
  include Votable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable, inverse_of: :linkable
  has_many :comments, dependent: :destroy, as: :commentable

  validates :body, presence: true, length: { minimum: 10 }

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  after_create :notify_subscribers

  private

  def notify_subscribers
    QuestionUpdateNotificationJob.perform_later(self.question)
  end
end
