class ApplicationController < ActionController::API
  rescue_from CanCan::AccessDenied do |exception|
    render json: {
      error: "Forbidden",
      message: exception.message
    }, status: :forbidden
  end
end