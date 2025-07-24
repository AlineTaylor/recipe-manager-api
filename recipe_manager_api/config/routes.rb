Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  #recipe-manager API routes
  resources :users, only: [:show, :update, :destroy]

  resources :recipes do
    resources :instructions, only: [:index, :create, :update, :destroy]
    resources :ingredient_lists, only: [:index, :create, :update, :destroy]
    resources :labels, only: [:index, :update]
  end
end
# TODO generate shoppinglist methods - maybe its own controller?
