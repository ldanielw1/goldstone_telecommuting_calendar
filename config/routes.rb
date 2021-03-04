Rails.application.routes.draw do

  # Dashboard routes
  resource :calendar, only: [] do
    get :view
  end
  root to: "calendar#view"

  # Session routes
  resources :sessions , only: [:create, :destroy, :login]
  get 'auth/:provider/callback',       to: 'sessions#create'
  get 'auth/failure',                  to: redirect('/')
  get 'signout',                       to: 'sessions#destroy', as: 'signout'
  get 'signin',                        to: 'sessions#login',   as: 'signin'
  get 'create_login',                  to: 'sessions#create',  as: 'create_login'
end
