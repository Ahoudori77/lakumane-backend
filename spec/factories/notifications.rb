FactoryBot.define do
  factory :notification do
    message { "在庫が不足しています" }
    association :user
    association :item
    read { false }
  end
end
