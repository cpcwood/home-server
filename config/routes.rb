Rails.application.routes.draw do
  root to: 'homepages#index'
  
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

  namespace :admin do
    resources :site_settings, only: [:index, :update]
    resources :images, only: [:index]
    resources :users, only: [:edit, :update]
    resources :header_images, only: [:update], path: '/header-images'
    resources :cover_images, only: [:update], path: '/cover-images'
    resource :about, only: [:edit, :update]
    resources :posts, only: [:index], path: "/blog"
    resources :posts, only: [:new, :create, :edit, :update, :destroy]
    resources :gallery_images, only: [:index], path: "/gallery"
    resources :gallery_images, only: [:new, :create, :edit, :update, :destroy], path: '/gallery-images'
    resources :posts, only: [:index], path: "/blog"
    resources :code_snippets, only: [:index, :new, :create, :edit, :update], path: "/code-snippets"
  end

  resource :about, only: [:show]

  get '/contact', to: 'contact_messages#new'
  resources :contact_messages, only: [:new, :create], path: 'contact-messages'

  resource :users, only: [:update]

  resources :posts, only: [:index, :show], path: "/blog"

  resources :gallery_images, only: [:index], path: "/gallery"

  resources :code_snippets, only: [:index, :show], path: "/code-snippets"
end
