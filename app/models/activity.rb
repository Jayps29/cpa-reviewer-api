class Activity < ApplicationRecord
  ACTIVITY_TYPES = %w[
    explanation
    multiple_choice
    true_false
    numeric_answer
    fill_in_the_blank
  ].freeze

  belongs_to :lesson
  has_many :activity_options, dependent: :destroy

  accepts_nested_attributes_for :activity_options,
                                allow_destroy: true

  validates :activity_type,
            presence: true,
            inclusion: {
              in: ACTIVITY_TYPES
            }

  validates :position, presence: true
  validates :position,
            uniqueness: {
              scope: :lesson_id,
              message: "has already been taken for this lesson"
            }

  validate :validate_activity_content

  private

  def validate_activity_content
    case activity_type
    when "explanation"
      if activity_options.any?
        errors.add(
          :activity_options,
          "are not allowed for explanation activities"
        )
      end

      if correct_answer.present?
        errors.add(
          :correct_answer,
          "is not allowed for explanation activities"
        )
      end

    when "multiple_choice"
      if activity_options.size < 2
        errors.add(
          :activity_options,
          "must have at least 2 options"
        )
      end

      if activity_options.count(&:is_correct) != 1
        errors.add(
          :activity_options,
          "must have exactly 1 correct option"
        )
      end

    when "true_false"
      if activity_options.size != 2
        errors.add(
          :activity_options,
          "must have exactly 2 options"
        )
      end

      if activity_options.count(&:is_correct) != 1
        errors.add(
          :activity_options,
          "must have exactly 1 correct option"
        )
      end

    when "numeric_answer", "fill_in_the_blank"
      if correct_answer.blank?
        errors.add(
          :correct_answer,
          "is required for this activity type"
        )
      end
    end
  end
end
