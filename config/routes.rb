ActionController::Routing::Routes.draw do |map|
  map.resources :teams do |team|
    team.resources :players
  end
  
  map.resources :calendars

  map.resources :tournaments do |tournament|
    tournament.resource :ilmo

    tournament.resources :players
    tournament.resources :referees
    tournament.resources :teams
    tournament.resources :assignments
    tournament.resources :team_assignments
  end

  map.resources :referees
  map.resources :assignments

  map.resources :users do |user|
    user.resources :targets
    user.resource :picture
  end

  map.connect "/images/*file_name", :controller => "pictures", :action => "display"

  map.resource :session

  
  map.login "/login", :controller=>"users", :action=>"index"
  map.logout "/logout", :controller=>"sessions", :action=>"destroy"
  
  # map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.root :controller => 'tournaments', :action => "index"

end
