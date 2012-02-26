Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = lambda { |env| SessionsController.action(:new).call(env) }
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end

Warden::Strategies.add(:password) do
  def valid?
    params['username'] && params['password']
  end

  def authenticate!
    user = User.find_by_username(params['username'])
    if user && user.authenticate(params['password'])
      success! user
    else
      fail 'Invalid username/password.'
    end
  end
end
