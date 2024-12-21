require 'rails_helper'

RSpec.describe "Items API", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:auth_headers) do
    post '/auth/sign_in', params: { email: user.email, password: 'password' }
    response.headers.slice('access-token', 'client', 'uid')
  end
  let!(:category) { create(:category, name: "文具") }
  let!(:item) { create(:item, category: category) }

  describe "GET /items" do
    it "全てのアイテムを取得できる" do
      get '/items', headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include(
        hash_including("name" => item.name, "category" => hash_including("name" => category.name))
      )
    end
  end

  describe "GET /items/:id" do
    context "存在するアイテムの場合" do
      it "アイテムを取得できる" do
        get "/items/#{item.id}", headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("name" => item.name, "category" => category.name)
      end
    end

    context "存在しないアイテムの場合" do
      it "エラーを返す" do
        get "/items/0", headers: auth_headers
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Item not found")
      end
    end
  end

  describe "POST /items" do
    context "有効なパラメータの場合" do
      it "アイテムを作成できる" do
        valid_params = {
          item: {
            name: "新しいアイテム",
            description: "新しい説明",
            category_id: category.id,
            shelf_number: "A-002",
            current_quantity: 100,
            optimal_quantity: 200,
            reorder_threshold: 50,
            unit: "個",
            manufacturer: "メーカー名",
            supplier_info: "取引先名",
            price: 123.45
          }
        }

        post '/items', params: valid_params, headers: auth_headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("name" => "新しいアイテム")
      end
    end

    context "無効なパラメータの場合" do
      it "エラーを返す" do
        invalid_params = { item: { name: "" } }
        post '/items', params: invalid_params, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end

  describe "PATCH /items/:id" do
    context "有効なパラメータの場合" do
      it "アイテムを更新できる" do
        valid_params = {
          item: {
            name: "更新されたアイテム名",
            current_quantity: 150
          }
        }
  
        patch "/items/#{item.id}", params: valid_params, headers: auth_headers
        expect(response).to have_http_status(:ok)
        updated_item = JSON.parse(response.body)
        expect(updated_item["name"]).to eq("更新されたアイテム名")
        expect(updated_item["current_quantity"]).to eq(150)
      end
    end
  
    context "無効なパラメータの場合" do
      it "エラーを返す" do
        invalid_params = { item: { name: "" } }
        patch "/items/#{item.id}", params: invalid_params, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  
    context "存在しないアイテムの場合" do
      it "エラーを返す" do
        patch "/items/0", params: { item: { name: "存在しないアイテム" } }, headers: auth_headers
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Item not found")
      end
    end
  end

  describe "DELETE /items/:id" do
    context "存在するアイテムの場合" do
      it "アイテムを削除できる" do
        expect {
          delete "/items/#{item.id}", headers: auth_headers
        }.to change { Item.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end
  
    context "存在しないアイテムの場合" do
      it "エラーを返す" do
        delete "/items/0", headers: auth_headers
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Item not found")
      end
    end
  end
end
