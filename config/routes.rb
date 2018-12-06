Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :flats, only: [:index, :show] do
    resources :favorites, only: [:create]
  end
  resources :favorites, only: [:index]
  resources :searches, only: [:index, :create]
end
