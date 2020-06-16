Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations",
    omniauth_callbacks: "users/omniauth_callbacks"}
  resources :reviews, only: [:index, :show]
  resources :users, only: [:index, :show, :edit, :update]
  resources :users do
    member do
      patch :ban_or_unban
      put :ban_or_unban
    end
  end
  resources :books do
    resources :reviews, except: :index
    member do
      patch :accept_request, :reject_request
      put :accept_request, :reject_request
    end
  end
  resources :categories
  resources :search, only: :index
  post 'search', to: 'search#fuzzy'
  resources :book_requests, only: :index
  resources :comments, only: :create
  resources :bookmarks, only: [:index, :create, :destroy]
  root "static_pages#home"
end
