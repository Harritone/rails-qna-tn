class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, as: :linkable, inverse_of: :linkable, dependent: :destroy
  has_one :badge, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, presence: true, length: { minimum: 10, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10 }

  belongs_to :user

  has_many_attached :files
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :badge, reject_if: :all_blank, allow_destroy: true

  def normal_answers
    # best_answer ? answers.where.not(id: best_answer.id) : answers
    answers.where.not(id: best_answer&.id) || answers
  end
end
