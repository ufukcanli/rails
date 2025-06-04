class User < ApplicationRecord
  has_many :sessions, dependent: :destroy

  MINIMUM_PASSWORD_LENGTH = 8

  has_secure_password

  validates :password, length: { minimum: MINIMUM_PASSWORD_LENGTH }
  validates :email, presence: true, uniqueness: true

  normalizes :email, with: ->(email) { email.strip.downcase }

  generates_token_for :password_reset, expires_in: 1.hour do
    password_salt.last(10)
  end
end
