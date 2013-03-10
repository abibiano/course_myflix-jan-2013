Myflix::Application.routes.draw do
  root to: 'static_pages#home'

  get 'ui(/:action)', controller: 'ui'

  get 'home', to: 'videos#home', as: 'home'

  get 'register(/:id)', to: 'users#new', as: 'register'
  get 'people', to: 'users#people', as: 'people'
  resources :users, only: [:create, :show]

  get 'sign_in', to: 'sessions#new', as: 'sign_in'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy', as: 'sign_out'

  get 'my_queue', to: 'queue_items#index', as: 'my_queue'
  resources :queue_items, only: [:create, :destroy] do
    collection do
      put :update, to: 'queue_items#update_multiple'
    end
  end

  get 'forgot_password', to: 'password_resets#new'
  get 'reset_password_confimation', to: 'password_resets#confirm'
  get 'password_resets(/:id)', to: 'password_resets#edit', as: 'edit_password_reset'
  resources :password_resets, only: [:create, :update]

  resources :relationships, only: [:create, :destroy]

  resources :videos, only: [:show] do
  	collection do
  		post 'search', to: 'videos#search'
  	end
    resources :reviews, only: [:create]
  end

  resources :invitations, only: [:new, :create]

end

