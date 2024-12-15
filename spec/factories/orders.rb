FactoryBot.define do
  factory :order do
    association :item
    quantity { 10 }
    status { "pending" }
  end
end
