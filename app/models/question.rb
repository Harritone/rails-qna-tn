class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, presence: true, length: { minimum: 10, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10 }

  belongs_to :user

  def normal_answers
    if best_answer
      answers.where.not(id: best_answer.id)
    else
      answers
    end
  end
end
