# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
CodingPrime::Application.config.session_store :cookie_store,
  :key         => '_codingprime_session_id'

CodingPrime::Application.config.secret_key_base = 'e1ef344f28789f0dc82c15997fc8ba48f540a2f41a141c263c76454f180e6d80264a74c1d6e7a668c902c78f8325dec0d5ae76e6ad2ff294ce53e404625e4e9a'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
