FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "My awesome title #{n}" }
    sequence(:body) { |n| "My really exhausting to solve problem #{n}" }

    trait :invalid do
      title { nil }
    end
  end
end
