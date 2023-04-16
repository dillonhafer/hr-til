require "rails_helper"

feature "Developer signs out" do
  it "Developer signs out" do
    # Given I am a signed in developer
    developer = sign_in_as

    expect {
      click_on "Sign Out"
    }.to change {
      # Then I should not see my username in the upper right
      # And I do not see the signout link
      has_selector?("a", text: developer.username) && has_selector?("a", text: "Sign Out")
    }.from(true).to(false)
  end
end
