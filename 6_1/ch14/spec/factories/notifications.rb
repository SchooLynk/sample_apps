FactoryBot.define do
  factory :notification do
    user { nil }
    notificatable { nil }
    parent { nil }
    children_count { 1 }
  end
end
