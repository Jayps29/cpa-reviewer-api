Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  namespace :api do
    namespace :v1 do
      get "/me", to: "me#show"
    end
  end


  get "/health", to: "health#show"
end