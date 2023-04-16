require "rails_helper"

feature "Developer signs out" do
  it "Developer signs out" do
    # Given I am a signed in developer
    developer = sign_in_as
    has_selector?("a", text: developer.username)
    has_selector?("a", text: "Sign Out")

    click_on "Sign Out"

    has_no_selector?("a", text: developer.username)
    has_no_selector?("a", text: "Sign Out")
  end
end
