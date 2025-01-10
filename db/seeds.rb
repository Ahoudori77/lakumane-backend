# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
items = Item.all
items.each do |item|
  Inventory.create!(
    item: item,
    current_quantity: rand(10..100),
    optimal_quantity: 50,
    reorder_threshold: 10,
    shelf_number: "A-#{item.id}",
    unit: "個",
    unit_price: rand(100..1000).to_d
  )
end