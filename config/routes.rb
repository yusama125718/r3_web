Rails.application.routes.draw do
  root :to => 'r3log#top'
  get 'about' => "r3log#about"
  post '/api/new', to: 'api#create'

  resources :stats, only: [:logs, :nw_d, :nw_s, :ow_d, :ow_s] do
    collection do
      get :logs
      get :nw_d
      get :nw_s
      get :ow_d
      get :ow_s
    end
  end

  resources :users, param: :id, only: [:index, :snow] do
    collection do
      get :index
    end
    resources :show, param: :info, only: [:index] do
      member do
        get :index, to: "users#show", param: :season
      end
    end
    # member do
    #   get :show, param: :id, param: :info
    # end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
end
