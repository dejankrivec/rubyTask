Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'auth/register', to: 'users#register'

  get 'getUsers', to: 'users#getUsers'
  get 'getFlowers', to: 'users#getFlowers'

  get 'getSightings', to: 'users#getSightingsByFlower'


  post 'createSighting', to: 'loggeduser#createSighting'
  post 'likeSighting', to: 'loggeduser#likeSighting'
  post 'destroySighting', to: 'loggeduser#destroySighting'
  post 'destroyLikes', to: 'loggeduser#destroyLikes'

  post 'auth/login', to: 'users#login'
end
