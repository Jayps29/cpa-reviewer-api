module Api
  module V1
    class ActivityAttemptsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_activity

      def create
        authorize! :read, @activity

        if @activity.activity_type == "explanation"
          render json: {
            error: "This activity does not require an answer"
          }, status: :unprocessable_entity

          return
        end

        submitted_answer = params[:answer]

        if submitted_answer.nil?
          render json: {
            error: "Answer is required"
          }, status: :unprocessable_entity

          return
        end

        result = ::ActivityAnswerChecker.new(
          @activity,
          submitted_answer
        ).call

        attempt = ActivityAttempt.create!(
          user: current_user,
          activity: @activity,
          answer: submitted_answer.to_s,
          correct: result[:correct]
        )

        render json: {
          attempt: {
            id: attempt.id,
            correct: attempt.correct
          },
          explanation: result[:explanation]
        }, status: :created
      end

      private

      def set_activity
        @activity = Activity.find(params[:activity_id])
      end
    end
  end
end
