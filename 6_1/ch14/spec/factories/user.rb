FactoryBot.define do
  factory :user do
    email { "a@example.com" }
    name { "a" }
    password { "111111" }
    activated { true }
  end
end
