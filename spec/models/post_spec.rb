require "rails_helper"

describe Post do
  let(:post) { FactoryBot.create(:post) }
  let(:valid_title) { "today-i-learned-about-clojure" }

  it "should have a valid factory" do
    expect(post).to be_valid
  end

  it "should require a body" do
    post.body = ""
    expect(post).to_not be_valid
  end

  it "should have a like count that defaults to one" do
    expect(post.likes).to eq 1
  end

  it "should require a developer" do
    post.developer = nil
    expect(post).to_not be_valid
  end

  it "should require a channel" do
    post.channel = nil
    expect(post).to_not be_valid
  end

  it "should require a title" do
    post.title = nil
    expect(post).to_not be_valid
  end

  it "should reject a title that is more than fifty chars" do
    post.title = "a" * 51
    expect(post).to_not be_valid
  end

  describe "#generate_slug" do
    it "should create a slug" do
      expect(post.slug).to be
    end

    it "should allow a custom slug" do
      custom_slugged_post = FactoryBot.create(:post, slug: "1234")
      expect(custom_slugged_post.slug).to eq "1234"
    end
  end

  describe "#slugified_title" do
    it "should create a slug with dashes" do
      post.title = "Today I learned about clojure"
      expect(post.send(:slugified_title)).to eq valid_title
    end

    it "should create a slug without multiple dashes" do
      post.title = "Today I learned --- about clojure"
      expect(post.send(:slugified_title)).to eq valid_title
    end

    it "should use title dashes in slug" do
      post.title = "Today I learned about clojure-like syntax feature"
      expect(post.send(:slugified_title)).to eq "today-i-learned-about-clojure-like-syntax-feature"
    end

    it "should remove whitespace from slug" do
      post.title = "  Today I             learned about clojure   "
      expect(post.send(:slugified_title)).to eq valid_title
    end

    it "should not allow punctuation in slug" do
      post.title = "Today I! learned? & $ % about #clojure"
      expect(post.send(:slugified_title)).to eq valid_title
    end

    it "should ignore and strip emojis" do
      post.title = "Today I learned about clojure 😀"
      expect(post.send(:slugified_title)).to eq valid_title
    end
  end

  describe "#body_size" do
    it "should return true when the post is equal or below 200 words" do
      post.body = "word " * 200
      expect(post).to be_valid
    end

    it "should return false when the post is above 200 words" do
      post.body = "word " * 201
      expect(post).to_not be_valid
      expect(post.errors.messages[:body]).to eq ["of this post is too long. It is 1 word over the limit of 200 words"]
    end

    it "should behave like a validation and return an appropriate messsage" do
      post.body = "word " * 200
      expect(post).to be_valid

      post.body = "word " * 201
      expect(post).to_not be_valid
      expect(post.errors.messages[:body]).to eq ["of this post is too long. It is 1 word over the limit of 200 words"]

      post.body = "word " * 300
      expect(post).to_not be_valid
      expect(post.errors.messages[:body]).to eq ["of this post is too long. It is 100 words over the limit of 200 words"]

      post.body = "word " * 400
      expect(post).to_not be_valid
      expect(post.errors.messages[:body]).to eq ["of this post is too long. It is 200 words over the limit of 200 words"]
    end
  end

  context "it should count its words" do
    it "with trailing spaces" do
      post = FactoryBot.create(:post, body: "word " * 150)
      expect(post.send(:word_count)).to eq 150
    end

    it "with no trailing spaces" do
      post = FactoryBot.create(:post, body: ("word " * 150).strip)
      expect(post.send(:word_count)).to eq 150
    end

    it "with one word" do
      post = FactoryBot.create(:post, body: "word")
      expect(post.send(:word_count)).to eq 1
    end
  end

  context "it should know how many words are available" do
    it "with trailing spaces" do
      post = FactoryBot.create(:post, body: "word " * 150)
      expect(post.send(:words_remaining)).to eq 50
    end

    it "with no trailing spaces" do
      post = FactoryBot.create(:post, body: ("word " * 150).strip)
      expect(post.send(:words_remaining)).to eq 50
    end

    it "with one word" do
      post = FactoryBot.create(:post, body: "word")
      expect(post.send(:words_remaining)).to eq 199
    end

    it "with too many words" do
      post = FactoryBot.build(:post, body: "word " * 300)
      expect(post.send(:words_remaining)).to eq(-100)
    end
  end

  describe "#search" do
    it "finds by developer" do
      needle = %w[brian jake].map do |author_name|
        FactoryBot.create :post, developer: FactoryBot.create(:developer, username: author_name)
      end.last

      expect(described_class.search("jake")).to eq [needle]
    end

    it "finds by channel" do
      needle = %w[vim ruby].map do |channel_name|
        FactoryBot.create :post, channel: FactoryBot.create(:channel, name: channel_name)
      end.last

      expect(described_class.search("ruby")).to eq [needle]
    end

    it "finds by title" do
      needle = %w[postgres sql].map do |title|
        FactoryBot.create :post, title: title
      end.last

      expect(described_class.search("sql")).to eq [needle]
    end

    it "finds by body" do
      needle = %w[postgres sql].map do |body|
        FactoryBot.create :post, body: body
      end.last

      expect(described_class.search("sql")).to eq [needle]
    end

    it "ranks matches by title, then developer or channel, then body" do
      posts = [
        FactoryBot.create(:post, body: "needle"),
        FactoryBot.create(:post, channel: FactoryBot.create(:channel, name: "needle")),
        FactoryBot.create(:post, developer: FactoryBot.create(:developer, username: "needle")),
        FactoryBot.create(:post, title: "needle")
      ].reverse

      ids = described_class.search("needle").pluck(:id)
      expect(ids[1..-2]).to match_array posts.map(&:id)[1..-2]
      expect([ids.first, ids.last]).to eq [posts.map(&:id).first, posts.map(&:id).last]
    end

    it "breaks ties by post date" do
      FactoryBot.create(:post, title: "older", body: "needle", created_at: 2.days.ago)
      FactoryBot.create(:post, title: "newer", body: "needle")

      expect(described_class.search("needle").map(&:title)).to eq %w[newer older]
    end
  end

  it "knows if its max likes count is a factor of ten" do
    method = :likes_threshold?

    post.max_likes = 10
    expect(post.send(method)).to eq true

    post.max_likes = 11
    expect(post.send(method)).to eq false
  end

  it "should never have a negative like count" do
    post.likes = -1

    expect(post).to_not be_valid
  end

  describe "#publish" do
    it "sets the post to published = true" do
      post.publish
      expect(post.published_at).to be
    end
  end

  describe ".popular" do
    it "returns published posts with five or more likes" do
      FactoryBot.create(:post, likes: 5)
      FactoryBot.create(:post, :draft, likes: 5)
      FactoryBot.create(:post, likes: 4)

      expect(described_class.popular.size).to eq 1
    end
  end

  context "slack integration on publication" do
    describe "new post, published is true" do
      it "should notify slack" do
        post = FactoryBot.build(:post)

        expect(post).to receive(:notify_slack)
        expect(post).to receive(:notify_basecamp)
        post.save
      end
    end

    describe "new post, published is false" do
      it "should not notify slack" do
        post = FactoryBot.build(:post, :draft)

        expect(post).to_not receive(:notify_slack)
        expect(post).to_not receive(:notify_basecamp)
        post.save
      end
    end

    describe "existing post, published changes to true" do
      it "should notify slack" do
        post = FactoryBot.create(:post, :draft)
        post.published_at = Time.now

        expect(post).to receive(:notify_slack)
        expect(post).to receive(:notify_basecamp)
        post.save
      end
    end
  end

  describe "#increment_likes" do
    it "increments max likes when likes equals max likes" do
      post = FactoryBot.create(:post, likes: 5, max_likes: 5)

      post.increment_likes
      expect(post.likes).to eq 6
      expect(post.max_likes).to eq 6
    end

    it "does not change max likes when likes are less than max likes" do
      post = FactoryBot.create(:post, likes: 3, max_likes: 5)

      post.increment_likes
      expect(post.likes).to eq 4
      expect(post.max_likes).to eq 5
    end
  end

  describe "#decrement_likes" do
    it "does not change max likes" do
      post = FactoryBot.create(:post, likes: 5, max_likes: 5)

      post.decrement_likes
      expect(post.likes).to eq 4
      expect(post.max_likes).to eq 5
    end
  end

  context "slack integration on tens of likes" do
    describe "reaches the milestone more than once" do
      it "should notify slack only once" do
        post = FactoryBot.create(:post, likes: 9, max_likes: 9)

        expect(post).to receive(:notify_slack).once
        expect(post).to receive(:notify_basecamp).once
        post.increment_likes # 10
        post.decrement_likes # 9
        post.increment_likes # 10

        post.increment_likes # 11
        post.decrement_likes # 10
      end
    end
  end
end
