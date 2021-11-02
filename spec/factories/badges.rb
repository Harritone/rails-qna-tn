FactoryBot.define do
  factory :badge do
    sequence(:name) { |n| "Badge #{n}" }
    question
    user { nil }
  end
end
