Myflix::Application.routes.draw do
  root to: 'static_pages#home'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#home', as: 'home'
  get 'register', to: 'users#new', as: 'register'
  get 'sign_in', to: 'sessions#new', as: 'sign_in'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy', as: 'sign_out'

  resources :videos, only: [:show] do
  	collection do
  		post 'search', to: 'videos#search'
  	end
    resources :reviews, only: [:create]
  end

 resources :users, only: [:create]

end