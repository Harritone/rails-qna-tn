class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges, dependent: :nullify
  has_many :votes, dependent: :nullify

  def author_of?(entity)
    return false unless entity.respond_to?(:user_id)
    entity.user_id == id
  end

  def voted_for?(resource)
    votes.where(votable: resource).present?
  end
end
