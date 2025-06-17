class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :account

  validates_associated :account
  validates :name, presence: true
  validates :email_adress, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
