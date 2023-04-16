require "rails_helper"

feature "Admin edits post" do
  it "Admin edits post" do
    # Given I am a signed in developer
    # And I am an admin
    developer = create(:developer, admin: true, username: "johnsmith", email: "johnsmith@example.com")
    sign_in_as(developer)

    # And a post exists by another developer
    @others_post = FactoryBot.create(:post)

    # When I visit the homepage
    visit root_path

    # When I click edit
    within ".post" do
      click_on "edit"
    end

    # Then I see the edit page for that post
    within "#post_edit" do
      expect(page).to have_content "Edit Post"
    end

    within "textarea#post_body" do
      expect(page).to have_content "Today I learned about web development"
    end

    # When I enter new information into that form
    fill_in "Title", with: "I changed the header"
    fill_in "Body", with: "I learned about changing content"

    # And I click submit
    click_on "Submit"

    # Then I see the show page for that edited post
    within ".post" do
      expect(page).to have_content "I changed the header"
      expect(page).to have_content "I learned about changing content"
    end

    # And I see a message "Post updated"
    expect(page).to have_content "Post updated"
  end
end
