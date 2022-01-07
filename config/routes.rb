require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create destroy update] do
        resources :answers, only: %i[index show create destroy update]
      end
    end
  end

  concern :votable do
    member do
      put :vote_up
      put :vote_down
      put :revote
    end
  end

  root to: 'questions#index'

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index
  resources :comments, only: :create

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, only: %i[create destroy update], concerns: :votable do
      member do
        patch :mark_best
      end
    end
  end

  resources :subscriptions, only: %i[create destroy]

  get '/email', to: 'users#email'
  post '/set_email', to: 'users#set_email'

  mount ActionCable.server => '/cable'
end
