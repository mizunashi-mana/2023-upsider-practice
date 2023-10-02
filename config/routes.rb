Rails.application.routes.draw do
  get '/api/sessions/get', to: 'sessions#get'
  post '/api/sessions/login', to: 'sessions#login'
  post '/api/sessions/logout', to: 'sessions#logout'

  post '/api/invoices', to: 'invoices#new'
  get '/api/invoices', to: 'invoices#list'
end
