  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
          post "users/" => "users#createUser"
          post "users/login" => "users#login"
          put "users/forgetPassword" => "users#forgetPassword"
          put "users/resetPassword/:id" => "users#resetPassword"
          # Api's for note entity
          post "notes/create_note" => "notes#create"
          get "notes/getNoteById/:id" => "notes#getNoteById"
          put "notes/trashToggle/:id" => "notes#trashToggle"
          put "notes/archiveToggle/:id" => "notes#archiveToggle" 
          put "notes/changeColor/:id" => "notes#changeColor"
          get "notes"  => "notes#index" 
      end
    end
  end