class ActivityAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :correct, inclusion: { in: [ true, false ] }
end
