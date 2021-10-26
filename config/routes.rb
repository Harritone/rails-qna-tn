Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[create destroy update] do
      member do
        patch :mark_best
      end
    end
  end
end
