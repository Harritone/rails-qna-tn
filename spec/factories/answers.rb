FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "My answer number #{n}" }
    association :question
  end
end
