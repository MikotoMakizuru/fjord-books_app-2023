Rails.application.routes.draw do
  root to: 'books#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get 'users/sign_out', to: 'devise/sessions#destroy'
  end

  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
