FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "My answer number #{n}" }
    association :question
    association :user

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      after(:build) do |answer|
        answer.files.attach(
        io: File.open("#{Rails.root}/spec/rails_helper.rb"),
        filename: 'rails_helper.rb')
      end
    end
  end
end
