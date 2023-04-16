require "rails_helper"

feature "Visitor cannot add or edit posts" do
  it "Visitor cannot add posts" do
    # Given I am a visitor
    visit root_path

    # When I try to add a post
    visit new_post_path

    # Then I see the homepage
    expect(current_path).to eq root_path
  end

  it "Visitor cannot edit posts" do
    # Given I am a visitor
    # And a post exists
    post = create(:post)

    # When I try to edit that post
    visit edit_post_path(post)

    # Then I see the homepage
    expect(current_path).to eq root_path
  end
end
