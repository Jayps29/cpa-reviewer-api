class Topic < ApplicationRecord
  belongs_to :subject

  validates :name, presence: true
end
