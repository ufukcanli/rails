class User < ApplicationRecord
  MINIMUM_PASSWORD_LENGTH = 8

  has_secure_password

  validates :password, length: { minimum: MINIMUM_PASSWORD_LENGTH }
end
