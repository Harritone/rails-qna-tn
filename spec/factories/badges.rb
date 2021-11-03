FactoryBot.define do
  factory :badge do
    sequence(:name) { |n| "Badge #{n}" }
    question
    user { nil }

    before(:create) do |badge|
      badge.image.attach(io: File.open("#{Rails.root}/public/badges/badge.jpg"), filename: 'badge.jpg')
    end
  end
end
