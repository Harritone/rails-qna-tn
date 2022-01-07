class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :links, as: :linkable, inverse_of: :linkable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy, as: :subscribable
  has_many :subscribers, through: :subscriptions, source: :user
  has_one :badge, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, presence: true, length: { minimum: 10, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10 }

  belongs_to :user

  has_many_attached :files
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :badge, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_author

  def normal_answers
    answers.where.not(id: best_answer&.id) || answers
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  def find_user_subscription(user)
    subscriptions.find_by(user: user)
  end

  private

  def subscribe_author
    Subscription.create(user: user, subscribable: self)
  end
end
