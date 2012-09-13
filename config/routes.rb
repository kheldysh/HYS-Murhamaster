HYSMurhamaster::Application.routes.draw do

  root :to => 'tournaments#index'

  resources :teams do
    resources :players
  end

  resources :calendars

  resources :tournaments do
    resources :ilmos
    resources :players
    resources :referees
    resources :teams
    resources :team_assignments
    resources :targets
    resources :rings
    resources :warrants
    resources :events
  end

  resources :referees do
    resources :players
  end

  resources :users do
    resources :targets
    resource :calendar
    resource :picture
  end

  match '/users/:id/reset_password' => 'users#reset_password'
  match '/images/*file_name' => 'pictures#display'
  resource :session
  match '/login' => 'users#index', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
end
