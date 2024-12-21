require 'rails_helper'

RSpec.describe "Inventory API", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:auth_headers) do
    post '/auth/sign_in', params: { email: user.email, password: 'password' }
    response.headers.slice('access-token', 'client', 'uid')
  end
  let!(:item) { create(:item, current_quantity: 10, optimal_quantity: 20, reorder_threshold: 5) }

  describe "GET /api/v1/inventory" do
    it "在庫リストを取得できる" do
      get "/api/v1/inventory", headers: auth_headers
      expect(response).to have_http_status(:ok)
      response_data = JSON.parse(response.body)
      expect(response_data).to include(
        hash_including("id" => item.id, "name" => item.name)
      )
    end

    it "認証なしでアクセスするとエラーを返す" do
      get "/api/v1/inventory"
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["errors"]).to include("You need to sign in or sign up before continuing.")
    end
  end

  describe "PATCH /api/v1/inventory/:id" do
    context "正常系" do
      it "在庫数を増やすことができる" do
        patch "/api/v1/inventory/#{item.id}", params: { quantity: 5 }, headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(item.reload.current_quantity).to eq(15)
      end

      it "在庫数を減らすことができる" do
        patch "/api/v1/inventory/#{item.id}", params: { quantity: -5 }, headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(item.reload.current_quantity).to eq(5)
      end

      it "在庫数がreorder_thresholdを下回る場合に警告メッセージを返す" do
        patch "/api/v1/inventory/#{item.id}", params: { quantity: -6 }, headers: auth_headers
        expect(response).to have_http_status(:ok)
        response_data = JSON.parse(response.body)
        expect(response_data["warning"]).to eq("Inventory is below reorder threshold")
      end
    end

    context "異常系" do
      it "在庫数が負の値になる場合エラーを返す" do
        patch "/api/v1/inventory/#{item.id}", params: { quantity: -20 }, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        response_data = JSON.parse(response.body)
        expect(response_data["error"]["message"]).to eq("Quantity cannot be negative")
      end

      it "存在しないアイテムの場合エラーを返す" do
        patch "/api/v1/inventory/0", params: { quantity: 5 }, headers: auth_headers
        expect(response).to have_http_status(:not_found)
        response_data = JSON.parse(response.body)
        expect(response_data["error"]["message"]).to eq("Item not found")
      end

      it "認証なしで更新リクエストを送るとエラーを返す" do
        patch "/api/v1/inventory/#{item.id}", params: { quantity: 5 }
        expect(response).to have_http_status(:unauthorized)
        response_data = JSON.parse(response.body)
        expect(response_data["errors"]).to include("You need to sign in or sign up before continuing.")
      end

      it "quantityがnilの場合エラーを返す" do
        patch "/api/v1/inventory/#{item.id}", params: { quantity: nil }, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        response_data = JSON.parse(response.body)
        expect(response_data["error"]["message"]).to eq("Quantity must be a number")
      end

      it "quantityが文字列の場合エラーを返す" do
        patch "/api/v1/inventory/#{item.id}", params: { quantity: "invalid" }, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        response_data = JSON.parse(response.body)
        expect(response_data["error"]["message"]).to eq("Quantity must be a number")
      end

      it "quantityが空文字の場合エラーを返す" do
        patch "/api/v1/inventory/#{item.id}", params: { quantity: "" }, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        response_data = JSON.parse(response.body)
        expect(response_data["error"]["message"]).to eq("Quantity must be a number")
      end
    end
  end
end
