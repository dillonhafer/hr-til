Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, fields: [:name, :email] unless Rails.env.production?
  provider :google_oauth2,
    ENV["google_client_id"],
    ENV["google_client_secret"],
    access_type: "online"
end

if !Rails.env.production?
  module OmniAuth
    module Strategies
      class Developer
        def request_phase
          form = OmniAuth::Form.new(title: "User Info", url: callback_path)
          options.fields.each do |field|
            form.text_field field.to_s.capitalize.tr("_", " "), field.to_s
          end

          form.define_singleton_method(:csrf) do |token|
            @html << "\n<input type='hidden' id='authenticity_token' name='authenticity_token' value='#{token}' />"
          end
          form.csrf(request.params["token"])

          form.button "Sign In"
          form.to_response
        end
      end
    end
  end
end
