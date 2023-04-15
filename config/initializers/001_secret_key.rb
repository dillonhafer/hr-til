# Heroku build back overrides secret key base, so reset it
ENV["SECRET_KEY_BASE"] = ENV["RAILS_SECRET_KEY_BASE"]
Rails.application.config.secret_key_base = ENV["RAILS_SECRET_KEY_BASE"]
