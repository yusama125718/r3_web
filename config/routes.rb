Rails.application.routes.draw do
  root :to => 'r3log#top'
  get 'stats/single'
  get 'stats/double'
  get 'stats/logs'
  get 'about' => "r3log#about"
  post '/api/new', to: 'api#create'

  resources :users do
    collection do
      get :index
    end
    member do
      get :show
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
end
