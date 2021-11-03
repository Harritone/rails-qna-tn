FactoryBot.define do
  factory :link do
    sequence(:name) { |n| "google #{n}" }
    url { "https://google.com" }
  end
end
