require 'bundler/capistrano'

set :rails_env, :production

set :application, "codingprime.com"
set :repository,  "http://github.com/t3hpr1m3/codingprime.git"
set :use_sudo, false

set :scm, :git
set :deploy_to, "/var/www/#{application}"
set :user, "titus"
set :deploy_via, :remote_cache

set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

server "komos.cedarhouselabs.com", :app, :web, :db, :primary => true

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec unicorn -c #{unicorn_config} -E #{rails_env} -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "kill `cat #{unicorn_pid}`"
  end

  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end

  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end
