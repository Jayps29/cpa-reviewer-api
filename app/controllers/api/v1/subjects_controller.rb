module Api
  module V1
    class SubjectsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_subject, only: [:show, :update, :destroy]

      def index
        authorize! :read, Subject

        subjects = Subject.all

        render json: {
          subjects: subjects
        }
      end

      def create
        authorize! :create, Subject

        subject = Subject.new(subject_params)

        if subject.save
          render json: {
            subject: subject
          }, status: :created
        else
          render json: {
            errors: subject.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def show
        authorize! :read, Subject
      
        render json: {
          subject: @subject
        }
      end

      def update
        authorize! :update, @subject

        if @subject.update(subject_params)
          render json: {
            subject: @subject
          }
        else
          render json: {
            errors: @subject.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, @subject

        @subject.destroy

        render json: {
          message: "Subject deleted successfully"
        }
      end

      private

      def set_subject
        @subject = Subject.find(params[:id])
      end

      def subject_params
        params.require(:subject).permit(:name, :description)
      end
    end
  end
end
