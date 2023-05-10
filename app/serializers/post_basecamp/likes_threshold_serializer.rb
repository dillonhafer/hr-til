class PostBasecamp::LikesThresholdSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :content

  def content
    likes = object.likes

    "#{object.developer_slack_display_name}'s post has #{likes} likes! " \
    "#{emojis[likes_index(likes)].to_sym || "😀"} - <a href='#{full_url}'>#{encoded_title}</a>"
  end

  private

  def encoded_title
    # Escape only three symbols:
    # https://api.slack.com/docs/formatting#how_to_escape_characters
    object.title.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
  end

  def full_url
    post_url(object)
  end

  def likes_index(likes)
    (likes / 10) - 1
  end

  def emojis
    ["🎉", "🎂", "✨", "💥", "❤️", "🎈", "👑", "🎓", "🏆", "💯 "]
  end
end
