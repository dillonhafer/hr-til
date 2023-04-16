module SessionHelper
  def sign_in_as(user = create(:developer))
    visit root_path
    find(".button_to button").click
    fill_in "name", with: user.username
    fill_in "email", with: user.email
    click_on "Sign In"

    expect(current_path).to eq root_path
    expect(page).to have_content user.username
  end
end
