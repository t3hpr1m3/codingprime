$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
require 'bundler/capistrano'

set :rvm_ruby_string, 'ruby-1.9.2'
set :application, "codingprime.com"
set :repository,  "http://github.com/t3hpr1m3/codingprime.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "/var/www/#{application}"
set :user, "titus"

server "foobizzle.com", :app, :web, :db, :primary => true

namespace :deploy do

  desc "Start unicorn"
  task :start, :except => {:no_release => true} do
    run "cd #{current_path}; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  desc "Stop unicorn"
  task :stop, :except => {:no_release => true} do
    run "kill -s QUIT `cat #{File.join(current_path, 'tmp', 'pids', 'unicorn.pid')}`"
  end

  desc "Restart unicorn"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{File.join(current_path, 'tmp', 'pids', 'unicorn.pid')}`"
  end
end
