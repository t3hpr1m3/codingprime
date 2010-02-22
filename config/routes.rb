ActionController::Routing::Routes.draw do |map|
  map.resources :posts, :has_many => :comments
  map.resources :sessions
  map.connect ':year/:month/:day/:slug.:format',
                :controller => 'posts',
                :action => 'show_by_slug',
                :year => /\d{4}/,
                :month => /\d{1,2}/,
                :day => /\d{1,2}/
  map.resources :users
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.root :posts
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
