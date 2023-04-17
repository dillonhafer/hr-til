require "rails_helper"

feature "Developer creates post" do
  let(:developer) { create(:developer) }
  let!(:channel) { create(:channel) }

  before do
    # Given I am a signed in developer
    sign_in_as(developer)

    # When I visit the homepage
    visit root_path

    # When I click create post
    click_on "Create Post"
    expect(page).to have_selector "h1", text: "Create Post"
  end

  it "With valid information" do
    # When I enter information into that form
    fill_in "Title", with: "Web Development"
    fill_in "Body", with: "I learned about Rails"

    # And I select a channel
    select channel.name, from: "Channel"

    # And I check "Publish this post"
    check "Publish this post"

    # And I click submit
    click_on "Submit"
    expect(page).to have_selector "#flash", text: "Post created"

    # Then I see the homepage
    visit root_path

    # And I see the post I created
    within ".post" do
      expect(page).to have_content developer.username
      expect(page).to have_content "I learned about Rails"
    end

    # And I see the channel I selected
    within ".post" do
      expect(page).to have_content(/##{channel.name}/i)
    end

    # When I click on my username in the admin panel
    within ".admin_panel" do
      click_on developer.username
    end

    # Then I see the post I created
    within ".post" do
      expect(page).to have_content developer.username
      expect(page).to have_content "I learned about Rails"
    end

    # When I click on the title of the post
    within ".post" do
      click_on "Web Development"
    end
  end

  it "With valid information and markdown inline code" do
    # When I enter information with markdown inline code into that form
    fill_in "Title", with: "Codified"
    markdown_content = "`killer robot attack`"
    fill_in "Body", with: markdown_content

    # And I select a channel
    select channel.name, from: "Channel"

    # And I check "Publish this post"
    check "Publish this post"

    # And I click submit
    click_on "Submit"
    expect(page).to have_selector "#flash", text: "Post created"

    # Then I see the homepage
    visit root_path

    # And I see the markdown inline code I created
    within ".post code" do
      expect(page).to have_content "killer robot attack"
    end
  end

  it "With valid information and markdown fenced code" do
    # When I enter information with markdown fenced code into that form
    fill_in "Title", with: "Fenced"
    markdown_content = "```javascript\nfirst line\nsecond line\nthird line\n```"
    fill_in "Body", with: markdown_content

    # And I select a channel
    select channel.name, from: "Channel"

    # And I check "Publish this post"
    check "Publish this post"

    # And I click submit
    click_on "Submit"
    expect(page).to have_selector "#flash", text: "Post created"

    # Then I see the homepage
    visit root_path
    expect(page).to have_selector "h1", text: "Fenced"

    # And I see the markdown fenced code I created
    within ".post" do
      expect(find("pre").native.text.chomp).to eq("first line\nsecond line\nthird line")
    end

    # And I see the fenced code labeled accurately
    expect(page).to have_selector "pre.javascript"
  end

  it "With valid information and markdown bullets" do
    # When I enter information with markdown bullets into that form
    fill_in "Title", with: "Bulletized"
    markdown_content = "* item from a list of items"
    fill_in "Body", with: markdown_content

    # And I select a channel
    select channel.name, from: "Channel"

    # And I check "Publish this post"
    check "Publish this post"

    # And I click submit
    click_on "Submit"
    expect(page).to have_selector "#flash", text: "Post created"

    # Then I see the homepage
    visit root_path

    # And I see the markdown bullets I created
    within ".post__content li" do
      expect(page).to have_content "item from a list of items"
    end
  end

  it "With invalid information (no post body)" do
    # When I click submit
    click_on "Submit"

    # Then I see an error message "Body can't be blank"
    expect(page).to have_selector(".field_with_errors", text: "Body can't be blank")
  end

  it "With invalid information (post body too long)" do
    # When I enter a long body into that form
    fill_in "Body", with: 100.times.map { "I love ruby" }.join(" ")

    # When I click submit
    click_on "Submit"

    # Then I see an error message "Body of this post is too long. It is 100 words over the limit of 200 words"
    expect(page).to have_selector(".field_with_errors", text: "Body of this post is too long. It is 100 words over the limit of 200 words")
  end

  it "With invalid information (no channel)" do
    # And I click submit
    click_on "Submit"

    # Then I see an error message "Channel can't be blank"
    expect(page).to have_selector(".field_with_errors", text: "Channel can't be blank")
  end

  it "Developer clicks cancel" do
    # When I click cancel
    expect {
      click_on "cancel"
    }.not_to change { Post.count }
  end

  it "Markdown preview", :javascript do
    # When I enter information with markdown fenced code into that form
    fill_in "Title", with: "Fenced"
    markdown_content = "```javascript\nfirst line\nsecond line\nthird line\n```"
    fill_in "Body", with: markdown_content

    # Then I see a markdown preview with my fenced code
    within ".post" do
      expect(page).to have_content "first line\nsecond line\nthird line"
    end

    # And I see the fenced code labeled accurately
    expect(page).to have_selector "pre.javascript"
  end

  it "Developer sees updating word count", :javascript do
    # When I enter 0 words into that form
    # Then I see a message saying I have 200 words left
    expect(page).to have_selector(".word_limit", text: "200 words available")

    # When I enter 1 word and a newline into that form
    fill_in "Body", with: "I"

    # Then I see a message saying I have entered 1 word
    expect(page).to have_selector(".word_count", text: "word count: 1")

    # And I see a message saying I have 199 words left
    expect(page).to have_selector(".word_limit", text: "199 words available")

    # When I enter 1 word into that form
    # Then I see a message saying I have entered 1 word
    # And I see a message saying I have 199 words left
    # When I enter 50 words into that form
    # Then I see a message saying I have entered 50 words
    # And I see a message saying I have 150 words left
    # When I enter 200 words into that form
    # Then I see a message saying I have entered 200 words
    # And I see a message saying I have 0 words left
    # When I enter 300 words into that form
    300.times do
      fill_in "Body", with: "I "
    end

    # Then I see a message saying I have entered 300 words
    expect(page).to have_selector(".word_count", text: "word count: 300")

    # And I see a message saying I have -100 words left
    # And the message is red
    expect(page).to have_selector(".word_limit.text-red", text: "-100 words available")
  end

  it "Developer cannot unpublish a post" do
    # Given I am a signed in developer
    # And I have an existing unpublished post
    create(:post, developer:)

    # When  I edit the post to be published
    visit root_path
    click_on "edit"

    # Then  I do not see a publish checkbox
    expect(page).to have_selector("h1", text: "Edit Post")
    expect(page).not_to have_content("Publish this post?")
  end

  it "Developer creates draft" do
    # Given I am a signed in developer
    # And   I have an existing unpublished post
    create(:post, published_at: nil, developer:)

    # When  I visit the posts page
    click_on "Drafts"

    # Then  I see the draft
    within ".post" do
      expect(page).to have_content developer.username
      expect(page).to have_content "Today I learned about web development"
      expect(page).to have_content "draft"
      expect(page).to_not have_content "previous TIL"
      expect(page).to_not have_content "next TIL"
    end

    within ".post:first-child aside" do
      expect(page).to_not have_content "like"
    end
  end

  it "Developer sees updating title char count", :javascript do
    # When  I enter 0 characters into the title field
    # Then  I see a message saying I have 50 characters left
    expect(page).to have_selector(".character_limit", text: "50 characters available")

    # When  I enter 1 character into the title field
    fill_in "Title", with: "I"

    # Then  I see a message saying I have 49 characters left
    expect(page).to have_selector(".character_limit", text: "49 characters available")

    # When  I enter 51 characters into the title field
    fill_in "Title", with: "I" * 51

    # Then  I see a message saying I have -1 characters left
    # And   the message is red
    expect(page).to have_selector(".character_limit.text-red", text: "-1 characters available")
  end
end
