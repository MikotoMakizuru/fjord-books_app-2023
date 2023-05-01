Rails.application.routes.draw do
  get '/', to: redirect('/books')

  scope "(:locale)", locale: /ja|en/ do
    resources :books
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
