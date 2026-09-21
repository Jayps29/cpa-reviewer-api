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

      resources :topics, only: [ :create, :update, :destroy ] do
        resources :lessons, only: [ :index, :create ]
      end

      resources :lessons, only: [ :update, :destroy ] do
        resources :activities, only: [ :index, :create ]

        get "/learn", to: "activities#learn"
        get "/study", to: "lessons#study"
        get "/progress", to: "lessons#progress"
      end

      resources :activities, only: [ :update, :destroy ]

      post "/activities/:activity_id/answer",
           to: "activity_attempts#create"
    end
  end

  get "/health", to: "health#show"
end
