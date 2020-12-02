Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get '/home/about' => 'homes#about', as: 'about'

  resources :users, only: [:show,:index,:create,:edit,:update,:destroy]
  resources :books
end