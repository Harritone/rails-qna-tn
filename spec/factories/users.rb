FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@mail.com" }
    password { 'P4ssword' }
    password_confirmation { 'P4ssword' }
  end

  trait :with_badges do
    transient do
      badge_count { 2 }
    end

    after(:create) do |user, evaluator|
      create_list(:badge, evaluator.badge_count, user: user)
    end
  end
end
