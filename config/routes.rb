Rails.application.routes.draw do
  resources :competitions
  resources :instructions, only: [:show]
  resources :users, only: [:show, :edit, :update]
  resources :teams, only: [:show, :new, :edit, :create, :update, :destroy]
  devise_for :users, path: 'auth'
  authenticated :user do
    root to:'competitions#index'
  end
end
