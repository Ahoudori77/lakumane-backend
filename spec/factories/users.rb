require 'faker'

FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    role { "事務" }
  end
end
