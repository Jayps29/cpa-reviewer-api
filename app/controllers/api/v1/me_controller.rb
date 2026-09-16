module Api
  module V1
    class MeController < ApplicationController
      before_action :authenticate_user!

      def show
        render json: {
          user: {
            id: current_user.id,
            name: current_user.name,
            email: current_user.email,
            role: resource.role
          }
        }
      end
    end
  end
end
