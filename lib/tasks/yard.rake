if Rails.env.development?
  require 'yard'
  YARD::Rake::YardocTask.new(:yard)
end
