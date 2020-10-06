Rails.application.routes.draw do
  root to: 'homepages#index'
  
  get '/about', to: 'abouts#index'

  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#new'
  get '/2fa', to: 'sessions#send_2fa'
  post '/2fa', to: 'sessions#verify_2fa'
  put '/2fa', to: 'sessions#reset_2fa'
  delete '/login', to: 'sessions#destroy'

  get '/forgotten-password', to: 'passwords#forgotten_password'
  post '/forgotten-password', to: 'passwords#send_reset_link'
  get '/reset-password', to: 'passwords#reset_password'
  post '/reset-password', to: 'passwords#update_password'

  get '/admin', to: 'admins#general'
  get '/admin/notifications', to: 'admins#notifications'
  get '/admin/analytics', to: 'admins#analytics'
  get '/admin/user_settings', to: 'admins#user_settings'

  namespace :admin do
    resources :site_settings, only: [:index, :update]
    resources :images, only: [:index]
    resources :header_images, only: [:update], :path => '/header-images'
    resources :cover_images, only: [:update], :path => '/cover-images'
  end

  get '/say-hello', to: 'homepages#index'

  resource :users, only: [:update]
end
