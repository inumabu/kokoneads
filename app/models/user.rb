class User < ApplicationRecord
  has_secure_password

  has_many :saved_tools, dependent: :destroy
  has_many :tool_histories, dependent: :destroy

  normalizes :email, with: ->(email) { email.strip.downcase }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :display_name, presence: true, length: { maximum: 40 }
end
