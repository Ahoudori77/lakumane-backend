FactoryBot.define do
  factory :item do
    name { "ボールペン" }
    description { "黒インクのボールペン" }
    category { create(:category) }
    shelf_number { "A-001" }
    current_quantity { 100 }
    optimal_quantity { 200 }
    reorder_threshold { 50 }
    unit { "本" }
    manufacturer { "某メーカー" }
    supplier_info { "取引先A" }
    price { 120.50 }
  end
end
