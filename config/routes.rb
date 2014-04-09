PaperclipExample::Application.routes.draw do
  
  resources :users
  resources :tags
  resources :posters

  root 'users#index'


  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  

  mount Api::V1::Server => '/api/v1', :as => 'api_v1'
  get '/:controller(/:action(/:id))'
  post '/:controller(/:action(/:id))'
  
end
