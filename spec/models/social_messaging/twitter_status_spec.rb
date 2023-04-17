require "rails_helper"

describe SocialMessaging::TwitterStatus do
  let(:developer) { FactoryBot.create(:developer, username: "cooldeveloper", twitter_handle: "handle") }
  let(:channel) { FactoryBot.create(:channel, name: "dreamwave", twitter_hashtag: "yodreamhashtag") }

  let(:post) do
    FactoryBot.build(:post,
      title: "Cool post",
      slug: "1234",
      developer: developer,
      channel: channel)
  end

  let(:twitter_status) { described_class.new(post) }

  describe "#status" do
    it "returns a Twitter status" do
      expected = "Cool post http://www.example.com/posts/1234-cool-post via @handle #til #yodreamhashtag"
      actual = twitter_status.send(:status)

      expect(actual).to eq expected
    end
  end

  describe "#post_to_twitter" do
    context "when update twitter is true" do
      before do
        allow(TwitterClient).to receive(:update)
        allow(twitter_status).to receive(:update_twitter_with_post).and_return("true")
      end

      it "updates the post" do
        post.save

        expect {
          twitter_status.post_to_twitter
        }.to change {
          post.reload.tweeted
        }.from(false).to(true)
      end

      it "calls Twitter update" do
        twitter_status.post_to_twitter
        expect(TwitterClient).to have_received(:update)
      end
    end
  end
end
