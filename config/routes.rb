Rails.application.routes.draw do
  root to: 'homepage#index'
  
  get '/about', to: 'about#index'

  get '/login', to: 'session#login'
  post '/login', to: 'session#new'
  get '/2fa', to: 'session#two_factor_auth'
  post '/2fa', to: 'session#two_factor_auth_verify'
  delete '/login', to: 'session#destroy'

  get '/admin', to: 'admin#index'

  get '/say-hello', to: 'homepage#index'
end
