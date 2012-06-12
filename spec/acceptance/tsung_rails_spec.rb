require 'acceptance/acceptance_helper'

feature "tsung-rails", %q{
  As a developer
  I want to load test my rails app
  So I can see how it behaves under stress
} do

  background do
  end

  scenario "Visit home page" do
    visit '/'
    page.should have_content("Welcome")
  end

end