Rails.application.routes.draw do
  resources :competitions
  resources :instructions, only: [:show]
  devise_for :users
  authenticated :user do
    root to:'competitions#index'
  end
end
