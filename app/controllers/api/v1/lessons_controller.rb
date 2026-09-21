module Api
  module V1
    class LessonsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_lesson, only: [ :update, :destroy ]

      def index
        authorize! :read, Lesson

        topic = Topic.find(params[:topic_id])
        lessons = topic.lessons.order(:position)

        render json: {
          lessons: lessons
        }
      end

      def create
        authorize! :create, Lesson

        topic = Topic.find(params[:topic_id])

        lesson = topic.lessons.new(lesson_params)

        if lesson.save
          render json: {
            lesson: lesson
          }, status: :created
        else
          render json: {
            errors: lesson.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, @lesson

        if @lesson.update(lesson_params)
          render json: {
            lesson: @lesson
          }
        else
          render json: {
            errors: @lesson.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, @lesson

        @lesson.destroy

        render json: {
          message: "Lesson deleted successfully"
        }
      end

      # ADD IT HERE
      def progress
        authorize! :read, Lesson

        lesson = Lesson.find(params[:lesson_id])

        activities = lesson.activities
                            .where.not(activity_type: "explanation")
                            .order(:position)

        total = activities.count

        attempts = ActivityAttempt
          .where(
            user: current_user,
            activity_id: activities.select(:id)
          )
          .order(:created_at)

        # Get the latest attempt for each activity
        latest_attempts = attempts
          .group_by(&:activity_id)
          .values
          .map(&:last)

        completed = latest_attempts.count

        correct = latest_attempts.count { |attempt| attempt.correct }

        percentage =
          if total.zero?
            0
          else
            ((completed.to_f / total) * 100).round
          end

        completed_lesson =
          total > 0 && completed >= total

        score = {
          correct: correct,
          total: total
        }

        render json: {
  progress: {
    completed_activities: completed,
    total_activities: total,
    percentage: percentage,
    score: score,
    completed: completed_lesson
  }
}
      end

      def study
        authorize! :read, Lesson

        lesson = Lesson.find(params[:lesson_id])

        render json: {
          lesson: lesson
        }
      end

      private

      def set_lesson
        @lesson = Lesson.find(params[:id])
      end

      def lesson_params
        params.require(:lesson).permit(
          :title,
          :description,
          :content,
          :position
        )
      end
    end
  end
end
