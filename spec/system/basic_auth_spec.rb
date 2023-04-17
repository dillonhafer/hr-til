require "rails_helper"

feature "Basic auth required" do
  it "does not require basic auth" do
    visit root_path
    expect(page.body.size > 1000).to eq(true)
  end

  context "when basic auth is in the env" do
    before do
      allow(ApplicationController).to receive(:basic_auth).and_return("username:password")
    end

    it "requires basic auth" do
      visit root_path
      expect(["<html><head></head><body></body></html>", "HTTP Basic: Access denied.\n"]).to include(page.body)
    end

    it "basic auth works" do
      if page.driver.browser.respond_to?(:authorize)
        page.driver.browser.authorize("username", "password")
      end

      visit root_url.gsub("//", "//username:password@")
      expect(page.body.size > 1000).to eq(true)
      expect(page.body.size > 1000).to eq(true)
    end
  end
end
