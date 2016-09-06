Rails.application.routes.draw do
  resources :competitions
  resources :instructions, only: [:show]
  devise_for :users
end
