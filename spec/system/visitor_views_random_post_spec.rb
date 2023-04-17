require "rails_helper"

feature "Visitor views statistics" do
  let!(:posts) { 10.times.map { create(:post, title: Phil.words(2).capitalize) } }

  it "Visitors views random post via button" do
    visit root_path
    click_on "Surprise Me"

    expect(page).to have_selector("#post_show")
    expect(posts.map(&:title)).to include(page.title.split(" - ").first)
    expect(current_path).to eq(random_path)
  end
end
