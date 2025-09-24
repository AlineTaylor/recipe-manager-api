class User < ApplicationRecord
  has_secure_password
  
# validations
  validates :email, presence: true, uniqueness: true, confirmation: true, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  validates :email_confirmation, presence: true, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }, on: :create

  validates :password, presence: true, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }, on: :create

  validates :first_name, :last_name, presence: true, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  validates :preferred_system, presence: true, inclusion: { in: %w(metric imperial) }
  validate :acceptable_profile_picture
  # associations
  has_many :recipes, dependent: :destroy
  # using active storage for pictures after all: it's well-supported for small-scale use, allegedly.
  has_one_attached :profile_picture

  # --finally-- implementing file type restrictions to most common image formats
  ALLOWED_IMAGE_CONTENT_TYPES = %w(image/jpeg image/png image/webp).freeze
  MAX_IMAGE_BYTES = 5.megabytes

  private

  def acceptable_profile_picture
    return unless profile_picture.attached?

    unless profile_picture.content_type.in?(ALLOWED_IMAGE_CONTENT_TYPES)
      errors.add(:profile_picture, "must be a JPEG, PNG, or WebP image")
    end

    if profile_picture.byte_size > MAX_IMAGE_BYTES
      errors.add(:profile_picture, "is too large (max 5 MB)")
    end
  end
end
