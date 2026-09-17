class Lesson < ApplicationRecord
  belongs_to :topic

  validates :title, presence: true
  validates :position, presence: true
end
