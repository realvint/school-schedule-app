Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: { sign_in: 'login', sign_up: 'registration' },
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}

  root 'static_pages#landing_page'

  resources :users, only: %i[index show edit update destroy]

  get 'privacy_policy', to: 'static_pages#privacy_policy'
end
