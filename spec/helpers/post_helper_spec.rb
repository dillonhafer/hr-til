require "rails_helper"

describe PostHelper do
  describe "#tweet_link" do
    context "returns a link to twitter" do
      specify "with appropriate data" do
        post = FactoryBot.create(:post, slug: "1234")

        expected_result = "<a href=\"http://twitter.com/share\" class=\"twitter-share-button\" data-text=\"Today I learned: Web Development\" data-via=\"hashrocket\" data-hashtags=\"phantomjs\" data-url=\"http://test.host/posts/1234-web-development\">Tweet</a>"

        expect(helper.tweet_link(post)).to eq expected_result
      end

      specify "with a developer's twitter handle" do
        developer = FactoryBot.create(:developer, twitter_handle: "awesomehandle")
        post = FactoryBot.create(:post, developer: developer)

        expected_result = "data-via=\"awesomehandle\""

        expect(helper.tweet_link(post)).to include expected_result
      end

      specify "with hashtag different from channel name" do
        developer = FactoryBot.create(:developer)
        channel = FactoryBot.create(:channel, name: "dashy-channel", twitter_hashtag: "popularhashtag")
        post = FactoryBot.create(:post, developer: developer, channel: channel)

        expected_result = "data-hashtags=\"popularhashtag\""

        expect(helper.tweet_link(post)).to include expected_result
      end
    end
  end
end
