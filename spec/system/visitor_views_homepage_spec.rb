require "rails_helper"

feature "Visitor views homepage" do
  it "Visitor sees company information" do
    # Given I am a visitor
    # And I visit the homepage
    visit root_path

    # And I see the site name in the title
    expect(page.title).to include SITE_NAME

    # Then I see the company branding
    within ".site_head" do
      expect(page).to have_link "Hashrocket", href: "https://hashrocket.com"
    end
  end

  it "Visitor sees Atom feed" do
    # Given I am a visitor
    # And a post exists
    create(:post)

    # When I visit the Atom feed page
    visit root_path(format: "atom")

    # Then I see an Atom feed
    expect(page).to have_content "?format=atom"
    expect(page).to have_content "Today I learned about web development"
  end

  it "Visitor sees About Us" do
    # Given I am a visitor
    # And I visit the homepage
    visit root_path

    # Then I should see a "?" button
    has_selector?("svg title", text: "About TIL")

    # And I should not see the About Us text
    has_no_selector?("p", text: "TIL is an open-source project by")

    # When I click "?"
    find("label[for=about]").click

    # Then I should see the About Us text
    has_selector?("p", text: "TIL is an open-source project by")

    # When I click "?"
    find("label[for=about]").click

    # And I should not see the About Us text
    has_no_selector?("p", text: "TIL is an open-source project by")
  end
end
