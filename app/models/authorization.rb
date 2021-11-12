class Authorization < ApplicationRecord
  belongs_to :user

  validates_presence_of :provider, :uid
end
