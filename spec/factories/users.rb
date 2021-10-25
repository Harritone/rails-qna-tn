FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@mail.com" }
    password { 'P4ssword' }
    password_confirmation { 'P4ssword' }
  end
end
