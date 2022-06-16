FactoryBot.define do
  factory :signed_in do
    association :user, strategy: :build
    remote_ip { "MyString" }
  end
end
