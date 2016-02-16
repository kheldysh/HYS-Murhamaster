HYSMurhamaster::Application.routes.draw do

  root to: 'tournaments#index'

  resources :teams do
    resources :players
  end

  resources :calendars

  resources :tournaments do
    resources :ilmos
    resources :players
    resources :referees
    resources :teams, controller: 'tournaments/teams'
    resources :team_assignments
    resources :targets
    resources :rings do
      resources :assignments
    end
    resources :warrants
    resources :events
  end

  resources :special_tournaments do
    resources :ilmos, controller: 'special_tournaments/ilmos'
    resources :targets, controller: 'special_tournaments/targets'
    resources :players, controller: 'special_tournaments/players'
  end

  resources :referees do
    resources :players
  end

  resources :users do
    resources :targets
    resource :calendar
    resource :picture
  end

  get '/tournaments/:tournament_id/register', to: 'ilmos#new', as: :tournament_registration
  match '/tournaments/:tournament_id/targets/:id/print' => 'targets#print'
  match '/users/:id/reset_password' => 'users#reset_password'
  # match '/images/*file_name' => 'pictures#display'
  match 'pictures/:id/:style.:format', controller: 'pictures', action: 'display', conditions: { method: :get }
  resource :session
  match '/login' => 'users#index', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout

  # FIXME dirty hack for ropecon
  match '/ropecon', controller: 'special_tournaments/targets', action: 'index', defaults: {special_tournament_id: Tournament.all.select(&:special_event?).last.id }
end
