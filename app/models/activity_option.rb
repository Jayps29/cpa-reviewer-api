class ActivityOption < ApplicationRecord
  belongs_to :activity

  validates :text, presence: true
  validates :position, presence: true
  validates :position,
            uniqueness: {
              scope: :activity_id,
              message: "has already been taken for this activity"
            }
  validates :is_correct, inclusion: { in: [ true, false ] }
end
