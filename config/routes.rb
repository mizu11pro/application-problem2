Rails.application.routes.draw do
  get 'search' => 'searchs#search'
devise_for :users
  root to: 'homes#top'
  get '/home/about' => 'homes#about', as: 'about'

  resources :users do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings'
    get 'followers' => 'relationships#followers'
  end

  resources :books do
    resources :book_comments, only: [:create,:destroy]
    resource :favorites, only: [:create,:destroy]
  end

  resources :ranks, only: [:index]

  # resources :searchs, only: [:index]
end