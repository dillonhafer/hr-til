require "rails_helper"

feature "Visitor searches posts" do
  before do
    # Given a post exists with the body "Needles are the thing we want"
    create(:post, body: "Needles are the thing we want")

    # And a post exists with the body "But what about all this hay?"
    create(:post, body: "But what about all this hay?")
  end

  it "Via address bar" do
    # And I visit the homepage
    # When I search for "needle" in the address bar
    visit root_path(q: "needle")

    # Then I am on the homepage
    expect(current_path).to eq root_path

    # And I see the "Needles" post
    expect(page.text).to match(/Needles/i)

    # And I do not see the "Hay" post
    expect(page.text).to_not match(/Hay/i)

    # And I see a header "1 post about needle"
    within ".page_head h1" do
      expect(page.text).to match(/1 post about needle/i)
    end
  end

  it "Via search form" do
    # And I visit the homepage
    visit root_path

    # When I search for "needle" in the search bar
    find("label[for=search_form]").click
    fill_in "q", with: "needle"
    click_on "Search"

    # Then I am on the homepage
    expect(current_path).to eq root_path
    has_selector? "h1", text: "1 post about needles"

    # And I see the "Needles" post
    expect(page.text).to match(/Needles/i)

    # And I do not see the "Hay" post
    expect(page.text).to_not match(/Hay/i)

    # And I see a header "1 post about needle"
    within ".page_head h1" do
      expect(page.text).to match(/1 post about needle/i)
    end
  end

  it "Via search form with no query" do
    # And I visit the homepage
    visit root_path

    # When I search for "" in the search bar
    find("label[for=search_form]").click
    fill_in "q", with: ""
    click_on "Search"

    # Then I am on the homepage
    expect(current_path).to eq root_path

    # And I see the "Needles" post
    expect(page.text).to match(/Needles/i)

    # And I see the "Hay" post
    expect(page.text).to match(/Hay/i)

    # And I don't see a search header
    expect(page).to_not have_selector ".page_head"
  end
end
