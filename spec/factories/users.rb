FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    email { "test@example.com" }
    encrypted_password { "password_hash" }
    role { "事務" }
  end
end
