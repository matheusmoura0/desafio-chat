Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  get '/users', to: 'users#index'   
  get '/messages/:other_user_id', to: 'messages#index'
  post '/messages', to: 'messages#create'
  
  get '/metrics', to: 'metrics#index'
end