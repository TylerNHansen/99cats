Manycats::Application.routes.draw do
  resources :cat_rental_requests, only: [:index, :create]
  get 'cats/:id/request', to: 'cat_rental_requests#new', as:
    :new_cat_rental_request
  resources :cats
  post 'cat_rental_requests/:id/approve', to: 'cat_rental_requests#approve',
    as: :approve_cat_rental_request
  post 'cat_rental_requests/:id/deny', to: 'cat_rental_requests#deny',
    as: :deny_cat_rental_request

  resources :users, only: [:new, :create]
  resource :session

  get 'sessions', to: 'sessions#index'

  delete 'sessions/:id', to: 'sessions#destroy_other', as: :kill_session

  root to: 'cats#index'
end
