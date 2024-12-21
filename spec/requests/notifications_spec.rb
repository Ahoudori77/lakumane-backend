require 'rails_helper'

RSpec.describe "Notifications API", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:auth_headers) do
    post '/auth/sign_in', params: { email: user.email, password: 'password' }
    response.headers.slice('access-token', 'client', 'uid')
  end
  let!(:item) { FactoryBot.create(:item) }
  let!(:notifications) { FactoryBot.create_list(:notification, 3, user: user, item: item, read: false) }
  let!(:unread_notifications) { create_list(:notification, 3, user: user, read: false) }


  describe "GET /api/v1/notifications" do
    it '未読の通知を取得できる' do
      Notification.delete_all # テスト前に通知を全削除
      create_list(:notification, 5, user: user, read: false) # 必要な5件のみ生成
      get '/api/v1/notifications', headers: auth_headers
      expect(response).to have_http_status(:ok)
      response_data = JSON.parse(response.body)
      expect(response_data['unread_count']).to eq(5) # 未読通知の件数
    end
  end
  
 
  describe 'GET /api/v1/notifications?page=1' do
    it '通知をページネートして取得できる' do
      Notification.delete_all # テスト前に通知を全削除
      create_list(:notification, 30, user: user) # 必要な30件のみ生成
      get '/api/v1/notifications?page=1', headers: auth_headers
      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)
      expect(data['notifications'].size).to eq(10) # 1ページあたり10件
      expect(data['total_pages']).to eq(3) # 30件 ÷ 10件/ページ = 3ページ
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
