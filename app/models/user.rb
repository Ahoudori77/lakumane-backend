class User < ApplicationRecord
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  has_many :notifications, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  include DeviseTokenAuth::Concerns::User
end
