Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'auth/register', to: 'users#register'

  get 'getUser', to: 'users#checkUser'

  post 'auth/login', to: 'users#login'
  get 'test', to: 'users#test'
end
