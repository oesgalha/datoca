Rails.application.routes.draw do
  resources :competitions
  devise_for :users
end
