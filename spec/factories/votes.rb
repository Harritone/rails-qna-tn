FactoryBot.define do
  factory :vote do
    result { 0 }
    association :user
    votable factory: :question
  end
end
