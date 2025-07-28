Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  #recipe-manager API routes
  resources :users, only: [:show, :update, :destroy, :create]

  resources :recipes do

    # instruction endpoints
    get 'instructions', on: :member
    post  'instructions',   to: 'recipes#create_instruction', on: :member
    patch  'instructions/:instruction_id', to: 'recipes#update_instruction'
    delete 'instructions/:instruction_id', to: 'recipes#destroy_instruction'

    # ingredient list endpoints
    
    post 'ingredient_lists', to: 'recipes#create_ingredient_list', on: :member
    patch 'ingredient_lists/:ingredient_list_id', to: 'recipes#update_ingredient_list'
    delete 'ingredient_lists/:ingredient_list_id', to: 'recipes#destroy_ingredient_list'
    # labels
    get 'labels', to: 'recipes#show_labels', on: :member
    patch 'labels', to: 'recipes#update_labels', on: :member

  end
end
# TODO generate shoppinglist methods - maybe its own controller?
