Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  use_doorkeeper
  resources :services
  devise_for :people

  resource :profile do
    get :change_password
  end

  namespace :admin do
    resources :people do
      member do
        get :edit_account
        get :change_password
      end
    end
  end

  cassy controllers: { sessions: "sessions" }

  root to: "home#index"
end
