Rails.application.config.session_store :cookie_store, 
  :key => '_my_session', 
  :expire_after => 7.days
  :secure => (Rails.env == 'production')