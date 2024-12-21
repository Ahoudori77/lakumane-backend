require 'rails_helper'

RSpec.describe "Notifications API", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:auth_headers) do
    post '/auth/sign_in', params: { email: user.email, password: 'password' }
    response.headers.slice('access-token', 'client', 'uid')
  end
  let!(:item) { FactoryBot.create(:item) }
  let!(:notifications) { FactoryBot.create_list(:notification, 3, user: user, item: item, read: false) }

  describe "GET /api/v1/notifications" do
    it "未読の通知を取得できる" do
      get "/api/v1/notifications", headers: auth_headers
      expect(response).to have_http_status(:ok)
      response_data = JSON.parse(response.body)
      expect(response_data.size).to eq(3)
      expect(response_data.first["read"]).to be_falsey
    end
  end

  describe "PATCH /api/v1/notifications/:id" do
    context "正常系" do
      it "通知を既読にできる" do
        notification = notifications.first
        patch "/api/v1/notifications/#{notification.id}", headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(notification.reload.read).to be_truthy
      end
    end

    context "異常系" do
      it "存在しない通知を指定した場合エラーを返す" do
        patch "/api/v1/notifications/0", headers: auth_headers
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Notification not found")
      end

      it "認証なしでリクエストを送るとエラーを返す" do
        patch "/api/v1/notifications/#{notifications.first.id}"
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["errors"]).to include("You need to sign in or sign up before continuing.")
      end
    end
  end
end
