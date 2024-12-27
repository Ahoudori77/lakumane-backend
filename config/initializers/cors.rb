Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001'  # フロントエンドのURLを指定
    resource '*',
      headers: :any,
      methods: [:get, :post, :patch, :put, :delete, :options],
      expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],  # 認証トークンをフロントに返す
      max_age: 600
  end
end
