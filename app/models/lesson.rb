class Lesson < ApplicationRecord
  belongs_to :topic

  validates :title, presence: true
  validates :position, presence: true
  validates :position,
            uniqueness: {
              scope: :topic_id,
              message: "has already been taken for this topic"
            }
end
