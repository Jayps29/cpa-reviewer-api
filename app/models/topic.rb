class Topic < ApplicationRecord
  belongs_to :subject
  has_many :lessons, dependent: :destroy

  validates :name, presence: true
end
