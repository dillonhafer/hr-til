class BasecampNotifier
  include Rails.application.routes.url_helpers
  # include SuckerPunch::Job
  include HTTParty

  base_uri "https://3.basecampapi.com"

  def perform(post, event)
    return if notify_endpoint.blank?
    response = self.class.post notify_endpoint,
      body: {content: body(post)},
      headers: {"Accept" => "application/json", "Content-Type" => "application/json"}
    unless response.success?
      raise "Sending message to basecamp failed with response #{response.code}"
    end
  end

  private

  def body(post)
    "#{post.developer_slack_display_name} created a new post - <a href=\"#{post_url(post)}\">#{post.title}</a> ##{post.channel_name}"
  end

  def notify_endpoint
    ENV["basecamp_line_endpoint"]
  end
end
