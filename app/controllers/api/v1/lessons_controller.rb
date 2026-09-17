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

      private

      def set_lesson
        @lesson = Lesson.find(params[:id])
      end

      def lesson_params
        params.require(:lesson).permit(
          :title,
          :description,
          :position
        )
      end
    end
  end
end
