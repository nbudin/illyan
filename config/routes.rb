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

  scope(path: "cas") do
    get 'login', :to => "sessions#new"
    post 'login', :to => "sessions#create"
    get 'logout', :to => "sessions#destroy"
    get 'serviceValidate', :to => "sessions#service_validate"
    get 'proxyValidate',   :to => "sessions#proxy_validate"
  end

  root to: "home#index"
end
