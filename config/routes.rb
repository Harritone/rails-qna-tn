Rails.application.routes.draw do
  devise_for :users

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

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, only: %i[create destroy update] do
      member do
        patch :mark_best
      end
    end
  end
end
