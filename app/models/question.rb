class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true
  validates :title, length: { minimum: 10, maximum: 255 }
  validates :body, length: { minimum: 10 }
end
