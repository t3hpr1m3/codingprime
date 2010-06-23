ActionController::Routing::Routes.draw do |map|
  map.resources :categories

  map.resources :posts do |post|
    post.resources :comments, :except => [:index, :update, :destroy]
  end
  map.resources :sessions, :users
  map.resources :comments, :only => [:index, :update, :destroy]
  map.connect ':year/:month/:day/:slug.:format',
                :controller => 'posts',
                :action => 'show_by_slug',
                :year => /\d{4}/,
                :month => /\d{1,2}/,
                :day => /\d{1,2}/
  #map.resources :users
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.root :posts
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
