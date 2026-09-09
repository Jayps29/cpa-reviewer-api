class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)

    sign_in(resource_name, resource)

    render json: {
      user: {
        id: resource.id,
        name: resource.name,
        email: resource.email
      }
    }, status: :ok
  end

  def destroy
    sign_out(resource_name)

    render json: {
      message: "Successfully signed out"
    }, status: :ok
  end
end