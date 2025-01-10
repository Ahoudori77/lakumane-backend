FactoryBot.define do
  factory :inventory do
    item_id { 1 }
    current_quantity { 1 }
    shelf_number { "MyString" }
  end
end
