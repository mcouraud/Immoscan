Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :flat, only: [:index, :show] do
    resources :favorite, only: [:index, :create]
  end
  resources :search, only: [:index, :create]
end
