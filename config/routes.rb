TheLifeWeb::Application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    # Devise
    #
    devise_for :users, only: [], singular: :user

    devise_scope :user do
      post('/authenticate', to: 'sessions#create')
      post('/register', to: 'registrations#create')
    end

    resources :friends, only: [:create, :destroy]
    resources :my_friends, only: [:index]
    resources :events, only: [:create]
    resources :my_events, only: [:index]
    resources :groups, only: [:create, :index, :destroy] do
      resources :users, only: [:index, :destroy]
    end
    resources :invite_requests, only: [:create], path: 'requests' do
      post :process, on: :member, to: 'invite_requests#handle'
    end
    resources :my_invite_requests, only: [:index], path: 'my_requests'
    resources :activities, only: [:index]
  end

  mount ApiTaster::Engine => '/api_taster' if defined? ApiTaster::Engine
end

ApiTaster::RouteCollector.collect! if defined? ApiTaster::Engine
