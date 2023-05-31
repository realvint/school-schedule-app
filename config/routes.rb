Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: { sign_in: 'login', sign_up: 'registration' },
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks',
               registrations: 'users/registrations'
             }

  root 'static_pages#landing_page'

  resources :users, only: %i[index show edit update destroy] do
    member do
      post :resend_invitation
    end
  end

  resources :classrooms

  get 'privacy_policy', to: 'static_pages#privacy_policy'
end
