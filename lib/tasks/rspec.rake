if Rails.env.development?
  require 'rspec/core/rake_task'
  task :default => :spec
end
