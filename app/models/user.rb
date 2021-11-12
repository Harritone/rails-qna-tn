class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:github]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges, dependent: :nullify
  has_many :votes, dependent: :nullify
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def author_of?(entity)
    return false unless entity.respond_to?(:user_id)
    entity.user_id == id
  end

  def voted_for?(resource)
    votes.where(votable: resource).present?
  end

  def self.find_for_oauth(data)
    FindForOauthService.new(data).call
  end
end
