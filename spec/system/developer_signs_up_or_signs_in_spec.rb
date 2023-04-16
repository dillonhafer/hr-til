require "rails_helper"

feature "Developer signs up or signs in" do
  it "Developer signs up" do
    # Given I am not already a developer
    # And I try to sign up or sign in with valid credentials
    # Then I am signed in
    expect {
      sign_in_as
    }.to change {
      Developer.count
    }.by(1)
  end

  it "Developer signs in" do
    # Given I am already a developer
    # And I try to sign up or sign in with valid credentials
    # Then I am signed in
    developer = create(:developer, username: "johnsmith", email: "johnsmith@example.com")
    expect {
      sign_in_as(developer)
    }.not_to change {
      Developer.count
    }
  end

  it "Guest signs in" do
    # Given I try to sign up with a white-listed guest email address
    # Then I am signed in
    # And a guest user is created
    allow(Developer).to receive(:permitted_emails).and_return("johnsmith@example.org")
    developer = build(:developer, username: "johnsmith", email: "johnsmith@example.org")
    expect {
      sign_in_as(developer)
    }.to change {
      Developer.count
    }
  end
end
