class User < ApplicationRecord
  has_secure_password
# validations
  validates :email, presence: true, uniqueness: true, confirmation: true, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  validates :email_confirmation, presence: true, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  validates :password, presence: true, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  validates :first_name, :last_name, presence: true, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  validates :preferred_system, presence: true, inclusion: { in: %w(metric imperial) }

  # associations
  has_many :recipes, dependent: :destroy
end
