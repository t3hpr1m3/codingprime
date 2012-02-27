if Rails.env.debug?
  require 'rspec/core/rake_task'
  task :default => :spec
end
