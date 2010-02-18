ActionController::Routing::Routes.draw do |map|
  map.resources :comments

  map.resources :posts, :users
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':year/:month/:day/:slug.:format', :controller => 'posts', :action => 'show'
  map.connect ':year/:month/:day/:slug', :controller => 'posts', :action => 'show'
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.root :controller => 'posts'
end
