Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  get '/users', to: 'users#index' # Crie um UsersController simples se precisar listar
  
  get '/messages/:other_user_id', to: 'messages#index'
  post '/messages', to: 'messages#create'
  
  get '/metrics', to: 'metrics#index'
end