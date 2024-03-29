class Developer < ApplicationRecord
  has_many :posts
  validates :email, presence: true, format: {with: proc { /\A(.+@(#{ENV['permitted_domains']})|(#{permitted_emails}))\z/ }}
  validates :username, presence: true, uniqueness: true, format: {with: /\A[A-Za-z0-9]+\Z/}
  validates :twitter_handle, length: {maximum: 15}, format: {with: /\A(?=.*[a-z])[a-z_\d]+\Z/i}, allow_blank: true

  def self.editor_options
    ["Text Field"].freeze
  end

  def self.permitted_emails
    ENV["permitted_emails"]
  end

  validates :editor, inclusion: {
    in: editor_options,
    message: "%{value} is not a valid editor"
  }

  def to_param
    username
  end

  def twitter_handle=(handle)
    self[:twitter_handle] = handle.gsub(/^@+/, "").presence
  end

  def slack_name=(name)
    self[:slack_name] = name.presence
  end

  def posts_count
    posts.published.count
  end

  def slack_display_name
    slack_name || username
  end
end
