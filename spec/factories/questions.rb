FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "My awesome title #{n}" }
    sequence(:body) { |n| "My really exhausting to solve problem #{n}" }
    association :user

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      after(:build) do |question|
        question.files.attach(
        io: File.open("#{Rails.root}/spec/rails_helper.rb"),
        filename: 'rails_helper.rb')
      end
    end

    trait :with_links do
      after(:build) do |question|
        create_list(:link, 3, linkable: question)
        # question.links << links
      end
    end
  end
end
