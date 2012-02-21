CodingPrime::Application.routes.draw do
  namespace :blog, :constraints => {:subdomain => /blog/} do
    resources :posts
    resources :categories
    resources :comments
    match '/' => 'posts#index'
    match ':year/:month/:day/:slug.:format',
                :controller => 'posts',
                :action => 'show_by_slug',
                :year => /\d{4}/,
                :month => /\d{1,2}/,
                :day => /\d{1,2}/
  end

  constraints :subdomain => /^(www|)$/ do
    match '/' => 'home#index'
  end

  resources :sessions, :users
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
end
