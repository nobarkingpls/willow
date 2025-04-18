class User < ApplicationRecord
  before_create :generate_api_token

  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  private

  def generate_api_token
    self.api_token = SecureRandom.hex(20)
  end
end
