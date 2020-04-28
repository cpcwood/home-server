Rails.application.routes.draw do
  root to: 'homepage#index'
  
  get '/about', to: 'about#index'

  get '/login', to: 'session#login'

  get '/admin', to: 'admin#index'

  get '/say-hello', to: 'homepage#index'
end
