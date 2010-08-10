ActionController::Routing::Routes.draw do |map|
  map.subdomain :blog do |blog|
    blog.resources :posts do |post|
      post.resources :comments, :except => [:index]
    end
    blog.resources :categories
    blog.resources :comments, :only => [:index]
    blog.root :controller => "posts"
    blog.connect ':year/:month/:day/:slug.:format',
                :controller => 'posts',
                :action => 'show_by_slug',
                :year => /\d{4}/,
                :month => /\d{1,2}/,
                :day => /\d{1,2}/
   
  end

  map.subdomain :www, :namespace => nil do |www|
    www.root :controller => 'home'
  end

  map.subdomain nil do |n|
    n.root :controller => 'home'
  end
  #, :path_prefix => '', :conditions => {:subdomain => 'blog'} do |blog|
  #  blog.resources :posts do |post|
  #    post.resources :comments, :except => [:index, :update, :destroy]
  #  end
  #  blog.root :controller => "posts"
  #end
  map.resources :sessions, :users
  #map.connect ':year/:month/:day/:slug.:format',
  #              :controller => 'blog/posts',
  #              :action => 'show_by_slug',
  #              :year => /\d{4}/,
  #              :month => /\d{1,2}/,
  #              :day => /\d{1,2}/
  #map.resources :users
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  #map.root :controller => "home", :action => "index"
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
