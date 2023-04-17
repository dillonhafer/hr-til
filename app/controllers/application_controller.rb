class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_cache_header
  before_action :authenticate_with_basic_auth

  authem_for :developer
  helper_method :editable?

  def self.basic_auth
    ENV["basic_auth_credentials"]
  end

  private

  def authenticate_with_basic_auth
    if (credentials = self.class.basic_auth)
      username, password = credentials.split(":", 2)
      authenticate_or_request_with_http_basic do |un, pw|
        un == username && pw == password
      end
    end
  end

  def editable?(post)
    current_developer && (current_developer == post.developer || current_developer.admin?)
  end

  def require_developer
    redirect_to root_path unless current_developer
  end

  def set_cache_header
    headers["Cache-Control"] = "no-cache, no-store"
  end
end
