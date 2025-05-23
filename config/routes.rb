# frozen_string_literal: true

UniversalAccess::Engine.routes.draw do
  root to: 'user_groups#index'

  resources :users do
    collection do
      get :autocomplete
    end
  end

  resources :user_groups do
    member do
      get :users
      post :add_user
      post :invite_user
      delete :remove_user
    end
  end
end
