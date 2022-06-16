FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "a#{n}@example.com" }
    sequence(:name) { |n| "a#{n}" }
    password { "111111" }
    activated { true }
  end
end
