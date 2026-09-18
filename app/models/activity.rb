class Activity < ApplicationRecord
  belongs_to :lesson

  validates :activity_type, presence: true
  validates :position, presence: true
  validates :position,
            uniqueness: {
              scope: :lesson_id,
              message: "has already been taken for this lesson"
            }
end
