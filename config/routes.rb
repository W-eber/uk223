Rails.application.routes.draw do
  get "audits/index"
  # Sessions routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Sign-up routes
  get "signup", to: "users#new"
  post "signup", to: "users#create"

  # Root route
  root "sessions#new"  # Login page as the root

  resources :audits, only: [:index]

  # Group routes
  resources :groups, only: [:index, :show, :new, :create, :destroy] do
    resources :debts, only: [:new, :create, :update]  # Nested routes for debts within groups
  end

  # Additional Group routes for user roles and kicking users
  resources :groups do
    patch 'update_user_role', on: :member
    delete 'kick_user', on: :member
  end

  # Route to join a group via code
  post "join_group", to: "groups#join"

  # User routes
  resources :users, only: [:show, :edit, :update]

  # Health check route
  get "up", to: "rails/health#show", as: :rails_health_check
end
