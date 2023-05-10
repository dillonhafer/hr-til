class BasecampNotifier
  # include SuckerPunch::Job
  include HTTParty

  base_uri "https://3.basecampapi.com"

  def perform(post, event)
    return if notify_endpoint.blank?
    response = self.class.post notify_endpoint,
      body: "PostBasecamp::#{event.classify}Serializer".constantize.new(post).to_json
    unless response.success?
      raise "Sending message to basecamp failed with response #{response.code}"
    end
  end

  private

  def notify_endpoint
    ENV["basecamp_line_endpoint"]
  end
end
