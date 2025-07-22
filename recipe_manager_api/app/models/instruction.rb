class Instruction < ApplicationRecord
  # validations
  validates :step_number, presence: true, length: { maximum: 500, too_long: "%{count} characters is the maximum allowed" }
  validates :step_content, presence: true, length: { maximum: 1000, too_long: "%{count} characters is the maximum allowed" }

  # associations
  belongs_to :recipe
end
