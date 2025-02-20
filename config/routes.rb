Rails.application.routes.draw do
  root :to => 'r3log#top'
  get 'about' => "r3log#about"
  get 'howto' => 'r3log#howto'

  get  '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  get  '/logout',  to: 'sessions#destroy'

  post '/api/new', to: 'api#create'
  get '/api/top', to: 'api#gettop'
  get '/api/rank', to: 'api#getrank'
  get '/api/status', to: 'api#getstatus'
  get '/api/util', to: 'api#getutil'

  resources :stats, only: [:logs, :nw_d, :nw_s, :ow_d, :ow_s] do
    collection do
      get :logs
      get :nw_d
      get :nw_s
      get :ow_d
      get :ow_s
      get :dma
    end
  end

  resources :admin, only: [:season] do
    collection do
      get :season, to: 'admin#season'
      post :season, to: 'admin#new_season'
    end
    member do
      delete :season, to: 'admin#delete_season'
      get "season/edit", to: 'admin#edit_season'
      post "season/edit", to: 'admin#update_season'
    end
  end

  resources :users, param: :id, only: [:index, :show] do
    collection do
      get :index
    end
    member do
      get :show, to: "users#show"
      post :show, to: "users#rename"
      delete :show, to: "users#delete"
    end
  end

  get '*not_found', to: 'application#routing_error'
  post '*not_found', to: 'application#routing_error'
end
