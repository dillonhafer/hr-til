require "rails_helper"

feature "Visitor views statistics" do
  it "Visitors views statistics via button" do
    # Given I am a visitor
    # When I visit the homepage
    visit root_path

    # And a post exists for each of the last 35 days
    Date.today.downto(Date.today - (35 - 1)) do |date|
      create(:post, created_at: date.end_of_day)
    end

    # And I click "statistics"
    click_on "Statistics"

    # Then I see statistics
    expect(page).to have_title "Statistics"
    expect(current_path).to eq statistics_path

    within "#activity" do
      expect(page).to have_selector "li", count: 30
    end

    within "#channels" do
      expect(page).to have_link "a", count: 35
      expect(page).to have_content "phantomjs", count: 35
    end

    within "#authors" do
      expect(page).to have_link "a", count: 35
      expect(page).to have_content "username", count: 35
    end
  end

  it "Visitors views statistics when there are no recent posts" do
    # Given I am a visitor
    # When I visit the homepage
    visit root_path

    # And 35 posts exist more than thirty days old
    FactoryBot.create_list(:post, 35, published_at: 1.year.ago)

    # And I click "statistics"
    click_on "Statistics"

    # Then I see statistics
    expect(page).to have_title "Statistics"
    expect(current_path).to eq statistics_path

    within "#activity" do
      expect(page).to have_selector "li", count: 30
    end

    within "#channels" do
      expect(page).to have_link "a", count: 35
      expect(page).to have_content "phantomjs", count: 35
    end

    within "#authors" do
      expect(page).to have_link "a", count: 35
      expect(page).to have_content "username", count: 35
    end
  end

  it "Visitors views post total counts" do
    # Given I am a visitor
    # And 35 posts exist in 5 channels
    channels = create_list(:channel, 5)
    35.times do
      FactoryBot.create(:post, channel: channels.sample)
    end

    # When I visit the statistics page
    visit root_path
    click_on "Statistics"

    # Then I see "35 posts in 5 channels"
    expect(page).to have_title "Statistics"
    expect(current_path).to eq statistics_path
    expect(page).to have_content("35 posts in 5 channels")
  end

  it "Visitors views post total counts" do
    # Given I am a visitor
    # And there are 6 authors who have authored posts
    create_list(:developer, 6).each do |a|
      create(:post, developer: a)
    end

    # And there are 2 authors who have not authored posts
    create_list(:developer, 2)

    # When I visit the statistics page
    visit root_path
    click_on "Statistics"

    # Then I see "6 authors"
    expect(page).to have_title "Statistics"
    expect(current_path).to eq statistics_path
    expect(page).to have_content("6 authors")
  end
end
