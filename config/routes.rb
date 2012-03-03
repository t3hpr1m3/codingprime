CodingPrime::Application.routes.draw do
  scope module: 'blog', as: 'blog', constraints: {subdomain: /blog/} do
    resources :posts do
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
    resources :categories
    resources :comments, only: [:index, :show]
    root to: 'posts#index'
    get ':year/:month/:day/:slug', to: 'posts#show_by_slug', as: 'post_by_slug', constraints: {
      year: /\d{4}/,
      month: /\d{1,2}/,
      day: /\d{1,2}/
    }
  end

  constraints subdomain: /^(www|)$/ do
    root to: 'home#index'
  end

  resources :sessions, :users
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
end
