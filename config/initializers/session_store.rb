# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_boxroom_session',
  :secret      => 'e13fff47b340f218b51f3809aaafd07a0878388f5919f481305e3ff7cdb0cbc68e9500d1d145500a4b2999ffbd7dccf9db9910f0ec5efe4f3e90bcced7f35c5f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
