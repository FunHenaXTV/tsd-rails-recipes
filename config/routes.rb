Rails.application.routes.draw do
  resources :ingredients, only: %i[ create edit update destroy ]
  resources :recipes
  devise_for :users
  root "hello#index"
end
