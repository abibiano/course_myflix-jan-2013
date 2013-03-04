Myflix::Application.routes.draw do
  get "password_resets/new"

  root to: 'static_pages#home'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#home', as: 'home'
  get 'register', to: 'users#new', as: 'register'
  get 'sign_in', to: 'sessions#new', as: 'sign_in'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy', as: 'sign_out'
  get 'my_queue', to: 'queue_items#index', as: 'my_queue'
  get 'people', to: 'users#people', as: 'people'
  get 'forgot_password', to: 'password_resets#new', as: 'forgot_password'

  get 'password_resets(/:id)', to: 'password_resets#edit', as: 'edit_password_reset'
  resources :password_resets, only: [:create, :update]

  resources :relationships, only: [:create, :destroy]

  resources :videos, only: [:show] do
  	collection do
  		post 'search', to: 'videos#search'
  	end
    resources :reviews, only: [:create]
  end

 resources :users, only: [:create, :show]
 resources :queue_items, only: [:create, :destroy] do
  collection do
    put :update, to: 'queue_items#update_multiple'
  end
 end


end

