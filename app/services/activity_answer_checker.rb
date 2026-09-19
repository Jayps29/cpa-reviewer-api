class ActivityAnswerChecker
  def initialize(activity, answer)
    @activity = activity
    @answer = answer
  end

  def call
    case @activity.activity_type
    when "multiple_choice", "true_false"
      check_option
    when "numeric_answer", "fill_in_the_blank"
      check_text_answer
    when "explanation"
      {
        correct: false,
        explanation: "This activity does not require an answer."
      }
    else
      {
        correct: false,
        explanation: "Unsupported activity type."
      }
    end
  end

  private

  def check_option
    option = @activity.activity_options.find_by(id: @answer)

    {
      correct: option.present? && option.is_correct,
      explanation: @activity.explanation
    }
  end

  def check_text_answer
    submitted_answer = @answer.to_s.strip.downcase
    correct_answer = @activity.correct_answer.to_s.strip.downcase

    {
      correct: submitted_answer == correct_answer,
      explanation: @activity.explanation
    }
  end
end
