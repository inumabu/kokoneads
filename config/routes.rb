Rails.application.routes.draw do
  root "tools#index"
  get "tools/:slug", to: "tools#show", as: :tool
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"
  get "account", to: "account#show"
  post "tools/:slug/save", to: "saved_tools#create", as: :save_tool
  delete "tools/:slug/save", to: "saved_tools#destroy", as: :unsave_tool
  post "tools/:slug/history", to: "tool_histories#create", as: :tool_history
  get "up" => "rails/health#show", as: :rails_health_check
end
