require "rails_helper"

feature "Visitor views channels" do
  let!(:channel) { create(:channel) }

  before do
    # Given I am a visitor
    # And a channel exists
    # And there are posts in that channel
    FactoryBot.create_list(:post, 3, channel:)
  end

  it "Posts exist" do
    # When I visit '/that channel'
    visit "/phantomjs"

    # Then I see all posts with that channel
    expect(page).to have_content "3 posts about #phantomjs"
    expect(page).to have_selector ".post", count: 3
    expect(page.title).to include "Posts about phantomjs - Today I Learned"
  end

  it "Visitor clicks channel name from post" do
    # And I visit the homepage
    visit root_path

    # When I click the channel
    first(".post").click_link "#phantomjs"

    # Then I see all posts with that channel
    expect(page).to have_content "3 posts about #phantomjs"
    expect(page).to have_selector ".post", count: 3
    expect(page.title).to include "Posts about phantomjs - Today I Learned"
  end

  it "Channel list excludes drafts" do
    # Given I am a visitor
    # And four posts exist, one a draft, in the same channel
    FactoryBot.create(:post, published_at: nil, channel:)

    # When I visit the channel page
    visit channel_path(channel)

    # Then I see only 3 published posts
    within ".page_head h1" do
      expect(page).to have_content "3 posts"
    end
    expect(page).to have_selector(".post", count: 3)
  end
end
