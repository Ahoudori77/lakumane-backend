require 'rails_helper'

RSpec.describe 'UsageRecords API', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:auth_headers) do
    post '/auth/sign_in', params: { email: user.email, password: 'password' }
    response.headers.slice('access-token', 'client', 'uid')
  end
  let!(:item) { FactoryBot.create(:item) }

  describe 'POST /usage_records' do
    context '正常系' do
      it '使用履歴の作成に成功する' do
        post usage_records_path, params: {
          usage_record: {
            item_id: item.id,
            user_id: user.id,
            usage_date: '2024-12-12',
            quantity: 5,
            reason: '在庫補充'
          }
        }, headers: auth_headers

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['quantity']).to eq(5)
      end
    end

    context '異常系' do
      it 'item_idが空の場合エラーを返す' do
        post usage_records_path, params: {
          usage_record: {
            item_id: nil,
            user_id: user.id,
            usage_date: '2024-12-12',
            quantity: 5,
            reason: '在庫補充'
          }
        }, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Item must exist")
      end

      it 'user_idが空の場合エラーを返す' do
        post usage_records_path, params: {
          usage_record: {
            item_id: item.id,
            user_id: nil,
            usage_date: '2024-12-12',
            quantity: 5,
            reason: '在庫補充'
          }
        }, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("User must exist")
      end

      it 'usage_dateが空の場合エラーを返す' do
        post usage_records_path, params: {
          usage_record: {
            item_id: item.id,
            user_id: user.id,
            usage_date: nil,
            quantity: 5,
            reason: '在庫補充'
          }
        }, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Usage date can't be blank")
      end

      it 'quantityが空の場合エラーを返す' do
        post usage_records_path, params: {
          usage_record: {
            item_id: item.id,
            user_id: user.id,
            usage_date: '2024-12-12',
            quantity: nil,
            reason: '在庫補充'
          }
        }, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Quantity can't be blank")
      end

      it 'quantityが0以下の場合エラーを返す' do
        post usage_records_path, params: {
          usage_record: {
            item_id: item.id,
            user_id: user.id,
            usage_date: '2024-12-12',
            quantity: -1,
            reason: '在庫補充'
          }
        }, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Quantity must be greater than 0")
      end

      it 'reasonが空の場合エラーを返す' do
        post usage_records_path, params: {
          usage_record: {
            item_id: item.id,
            user_id: user.id,
            usage_date: '2024-12-12',
            quantity: 5,
            reason: nil
          }
        }, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Reason can't be blank")
      end
    end
  end
end
