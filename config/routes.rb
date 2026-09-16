Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  namespace :api do
    namespace :v1 do
      get "/me", to: "me#show"

      resources :subjects, only: [ :index, :show, :create, :update, :destroy ] do
        resources :topics, only: [ :index ]
      end

      resources :topics, only: [ :create, :update, :destroy ]
    end
  end

  get "/health", to: "health#show"
end
