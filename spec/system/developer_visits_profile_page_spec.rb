require "rails_helper"

feature "Developer visits profile page" do
  let(:developer) { create(:developer) }
  before do
    # Given I am a signed in developer with email "foo@example.com"
    sign_in_as(developer)

    # When I visit the homepage
    visit root_path

    # And I click profile
    click_on "Profile"

    # Then I see my profile page
    within "#profile_edit" do
      expect(page).to have_content "My Profile"
    end
  end

  it "Adds a twitter handle" do
    # And I see my email "foo@example.com"
    expect(page).to have_content(developer.email)

    # When I enter my twitter handle
    fill_in "Twitter handle", with: "hashrocket"

    # And I click the "Submit" button
    click_on "Submit"

    # Then I see "Developer updated"
    has_selector? "#flash", text: "Developer updated"

    # Then I see the homepage
    expect(current_path).to eq root_path

    # And my twitter handle is set
    expect(developer.reload.twitter_handle).to eq "hashrocket"
  end

  it "Adds an invalid twitter handle" do
    # When I enter an invalid twitter handle
    fill_in "Twitter handle", with: "a.!&"

    # And I click the "Submit" button
    click_on "Submit"

    # Then I see an error message "Twitter handle is invalid"
    expect(page).to have_selector(".field_with_errors", text: "Twitter handle")
  end

  it "Can submit form without entering a Twitter handle" do
    # And I click the "Submit" button
    click_on "Submit"

    # Then I see "Developer updated"
    has_selector? "#flash", text: "Developer updated"

    # Then I see the homepage
    expect(current_path).to eq root_path
  end

  it "Sets editor to a Text Field" do
    # When I change my editor to "Text Field"
    # And I click the "Submit" button
    # Then I see the homepage
    # When I visit the new post page
    # Then I see a form for posts
    # And the editor is set to "Text Field"
  end

  it "Adds a Slack name" do
    # When I enter a Slack name
    fill_in "Slack name", with: "my_name"

    # And I click the "Submit" button
    click_on "Submit"

    # Then I see "Developer updated"
    has_selector? "#flash", text: "Developer updated"

    # And I click profile
    click_on "Profile"

    # Then I see my Slack name
    expect(page).to have_field("Slack name", with: "my_name")
  end
end
