Rails.application.routes.draw do
  resources :competitions
  resources :instructions, only: [:show]
  resources :users, only: [:show, :edit, :update]
  devise_for :users, path: 'auth'
  authenticated :user do
    root to:'competitions#index'
  end
end
