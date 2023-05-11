class BasecampNotifier
  include Rails.application.routes.url_helpers
  # include SuckerPunch::Job
  include HTTParty

  base_uri "https://3.basecamp.com"

  def perform(post, event)
    return if notify_endpoint.blank?
    response = self.class.post notify_endpoint,
      body: {content: body(post, event)}
    unless response.success?
      raise "Sending message to basecamp failed with response #{response.code}"
    end
  end

  private

  def body(post, event)
    if event == "create"
      "#{post.developer_slack_display_name} created a new post - <a href=\"#{post_url(post)}\">#{post.title}</a> ##{post.channel_name}"
    elsif event == "likes_threshold"
      likes = post.likes

      "#{post.developer_slack_display_name}'s post has #{likes} likes! " \
      "#{emojis[likes_index(likes)].to_sym || "😀"} - <a href=\"#{post_url(post)}\">#{post.title}</a>"
    end
  end

  def notify_endpoint
    ENV["basecamp_line_endpoint"]
  end

  def likes_index(likes)
    (likes / 10) - 1
  end

  def emojis
    ["🎉", "🎂", "✨", "💥", "❤️", "🎈", "👑", "🎓", "🏆", "💯 "]
  end
end
