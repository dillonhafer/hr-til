require "rails_helper"

feature "Developer views drafts" do
  it "Admin views drafts" do
    # Given I am a signed in developer
    # And I am an admin
    developer = create(:developer, admin: true, username: "johnsmith", email: "johnsmith@example.com")
    sign_in_as(developer)

    # And 2 drafts exist by another developer
    create_list(:post, 2, published_at: nil)

    # When I click "Drafts"
    click_on "Drafts"

    # Then I see 2 posts
    expect(page).to have_selector "article", count: 2
  end

  it "Non-admin views drafts" do
    # Given I am a signed in developer
    developer = create(:developer, admin: false, username: "johnsmith", email: "johnsmith@example.com")
    sign_in_as(developer)

    # And I have a draft post
    create(:post, developer:, published_at: nil)

    # And 5 drafts exist by another developer
    create_list(:post, 5, published_at: nil)

    # When I click "Drafts"
    click_on "Drafts"

    # Then I see 1 post
    expect(page).to have_selector "article", count: 1
  end
end
