Rails.application.routes.draw do
  root to: 'homepage#index'
  
  get '/about', to: 'about#index'

  get '/login', to: 'session#login'
  post '/login', to: 'session#new'
  get '/2fa', to: 'session#send_2fa'
  post '/2fa', to: 'session#verify_2fa'
  put '/2fa', to: 'session#reset_2fa'
  delete '/login', to: 'session#destroy'

  get '/forgotten-password', to: 'password#forgotten_password'
  post '/forgotten-password', to: 'password#send_reset_link'
  get '/reset-password', to: 'password#reset_password'
  post '/reset-password', to: 'password#update_password'

  get '/admin', to: 'admin#general'
  get '/admin/notifications', to: 'admin#notifications'
  get '/admin/analytics', to: 'admin#analytics'
  get '/admin/user-settings', to: 'admin#user_settings'

  get '/say-hello', to: 'homepage#index'

  resource :users, only: [:update]
end
