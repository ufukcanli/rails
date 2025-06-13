class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :app_sessions

  has_secure_password

  before_validation :strip_extraneous_spaces

  validates :name, presence: true
  validates :email,
              format: { with: URI::MailTo::EMAIL_REGEXP },
              uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 }

  private

    def strip_extraneous_spaces
      self.name = self.name&.strip
      self.email = self.email&.strip
    end
end
