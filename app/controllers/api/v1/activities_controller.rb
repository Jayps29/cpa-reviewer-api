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
        activities: activities.as_json(
          include: :activity_options
        )
      }
      end

      def learn
        authorize! :read, Lesson
      
        lesson = Lesson.find(params[:lesson_id])
        activities = lesson.activities.order(:position)
      
        render json: {
          lesson: {
            id: lesson.id,
            title: lesson.title,
            description: lesson.description,
            activities: activities.map { |activity| student_activity_json(activity) }
          }
        }
      end

      def create
        authorize! :create, Activity

        lesson = Lesson.find(params[:lesson_id])

        activity = lesson.activities.new(activity_params)

        if activity.save
          render json: {
          activity: activity.as_json(
            include: :activity_options
          )
        }, status: :created
        else
          render json: {
            errors: activity.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, @activity

        attrs = activity_params

        type_changed =
          attrs[:activity_type].present? &&
          attrs[:activity_type] != @activity.activity_type

        begin
          Activity.transaction do
            if type_changed
              @activity.activity_options.destroy_all
              @activity.reload

              options =
                attrs[:activity_options_attributes]&.reject do |option|
                  ActiveModel::Type::Boolean.new.cast(option[:_destroy])
                end

              attrs = attrs.except(:activity_options_attributes)
              attrs[:activity_options_attributes] = options if options
            end

            @activity.update!(attrs)
          end

          render json: {
            activity: @activity.as_json(
              include: :activity_options
            )
          }
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            errors: e.record.errors.full_messages
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
          :correct_answer,
          :position,
          activity_options_attributes: [
            :id,
            :text,
            :position,
            :is_correct,
            :_destroy
          ]
        )
      end

      def student_activity_json(activity)
        data = {
          id: activity.id,
          activity_type: activity.activity_type,
          title: activity.title,
          prompt: activity.prompt,
          position: activity.position
        }
      
        if activity.activity_type == "explanation"
          data[:explanation] = activity.explanation
        elsif %w[multiple_choice true_false].include?(activity.activity_type)
          data[:options] = activity.activity_options
            .order(:position)
            .map do |option|
              {
                id: option.id,
                text: option.text,
                position: option.position
              }
            end
        end
      
        data
      end
    end
  end
end
