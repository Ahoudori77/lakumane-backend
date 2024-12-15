require 'rails_helper'

RSpec.describe "Inventory API", type: :request do
  let!(:item) { create(:item, current_quantity: 10, optimal_quantity: 20, reorder_threshold: 5) }

  describe "GET /inventory" do
    it "在庫リストを取得できる" do
      get "/inventory"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include(
        { "id" => item.id, "name" => item.name, "current_quantity" => 10, "optimal_quantity" => 20, "reorder_threshold" => 5 }
      )
    end
  end

  describe "PATCH /inventory/:id" do
    context "正常系" do
      it "在庫数を増やすことができる" do
        patch "/inventory/#{item.id}", params: { quantity: 5 }
        expect(response).to have_http_status(:ok)
        expect(item.reload.current_quantity).to eq(15)
      end

      it "在庫数を減らすことができる" do
        patch "/inventory/#{item.id}", params: { quantity: -5 }
        expect(response).to have_http_status(:ok)
        expect(item.reload.current_quantity).to eq(5)
      end
    end

    context "異常系" do
      it "在庫数が負の値になる場合エラーを返す" do
        patch "/inventory/#{item.id}", params: { quantity: -20 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Quantity cannot be negative")
      end

      it "存在しないアイテムの場合エラーを返す" do
        patch "/inventory/0", params: { quantity: 5 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Item not found")
      end
    end
  end
end
