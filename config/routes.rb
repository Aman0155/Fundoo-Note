Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "users", to: "users#create"
      get "users", to: "users#index"
      get "users/:id", to: "users#show"
      delete "users/:id", to: "users#destroy"
      post "users/login" to: "users#userlogin"
    end
  end
end
