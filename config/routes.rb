Rails.application.routes.draw do
  resources :competitions do
    resources :acceptances, only: [:new, :create]
    resources :rankings, only: [:index]
    resources :submissions, only: [:index, :show, :new, :create]
  end
  resources :instructions, only: [:show]
  resources :users, only: [:show, :edit, :update]
  resources :teams, only: [:show, :new, :edit, :create, :update]
  devise_for :users,
    path: 'auth',
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  authenticated :user do
    root to:'competitions#index'
  end
end
