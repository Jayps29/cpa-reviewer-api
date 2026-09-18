module Api
  module V1
    class ActivitiesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_activity, only: [ :update, :destroy ]

      def index
        authorize! :read, Activity

        lesson = Lesson.find(params[:lesson_id])
        activities = lesson.activities.order(:position)

        render json: {
          activities: activities
        }
      end

      def create
        authorize! :create, Activity

        lesson = Lesson.find(params[:lesson_id])

        activity = lesson.activities.new(activity_params)

        if activity.save
          render json: {
            activity: activity
          }, status: :created
        else
          render json: {
            errors: activity.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, @activity

        if @activity.update(activity_params)
          render json: {
            activity: @activity
          }
        else
          render json: {
            errors: @activity.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, @activity

        @activity.destroy

        render json: {
          message: "Activity deleted successfully"
        }
      end

      private

      def set_activity
        @activity = Activity.find(params[:id])
      end

      def activity_params
        params.require(:activity).permit(
          :activity_type,
          :title,
          :prompt,
          :explanation,
          :position
        )
      end
    end
  end
end
