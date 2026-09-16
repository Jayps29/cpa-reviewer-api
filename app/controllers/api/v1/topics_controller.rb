module Api
  module V1
    class TopicsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_topic, only: [ :update, :destroy ]

      def index
        authorize! :read, Topic

        subject = Subject.find(params[:subject_id])
        topics = subject.topics

        render json: {
          topics: topics
        }
      end

      def create
        authorize! :create, Topic

        topic = Topic.new(topic_params)

        if topic.save
          render json: {
            topic: topic
          }, status: :created
        else
          render json: {
            errors: topic.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, @topic

        if @topic.update(topic_params)
          render json: {
            topic: @topic
          }
        else
          render json: {
            errors: @topic.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, @topic

        @topic.destroy

        render json: {
          message: "Topic deleted successfully"
        }
      end

      private

      def set_topic
        @topic = Topic.find(params[:id])
      end

      def topic_params
        params.require(:topic).permit(:name, :description, :subject_id)
      end
    end
  end
end
