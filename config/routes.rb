Rails.application.routes.draw do
  root to: 'homepage#index'
  get '/say-hello', to: 'homepage#index'
end
