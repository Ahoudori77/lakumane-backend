require 'rails_helper'

RSpec.describe "Orders API", type: :request do
  let!(:item) { create(:item) }
  let!(:orders) { create_list(:order, 5, item: item, status: "pending") }

  describe "GET /orders" do
    it "発注リストを取得できる" do
      get "/orders"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(5)
    end
  end

  describe "POST /orders" do
    context "正常系" do
      it "新しい発注を作成できる" do
        post "/orders", params: { order: { item_id: item.id, quantity: 10, status: "pending" } }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["quantity"]).to eq(10)
      end
    end

    context "異常系" do
      it "quantityが0以下の場合エラーを返す" do
        post "/orders", params: { order: { item_id: item.id, quantity: 0, status: "pending" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Quantity must be greater than 0")
      end

      it "statusが不正な値の場合エラーを返す" do
        post "/orders", params: { order: { item_id: item.id, quantity: 10, status: "invalid_status" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Status is not included in the list")
      end
    end
  end
end
