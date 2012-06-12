require 'spec_helper.rb'
require 'capybara/rspec'


def use_tsung_proxy
  Capybara.register_driver :selenium do |app|
    require 'selenium/webdriver'
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['network.proxy.type'] = 1 # manual proxy config
    profile['network.proxy.http'] = 'localhost'
    profile['network.proxy.no_proxies_on'] = ''
    profile['network.proxy.http_port'] = 8090
    Capybara::Selenium::Driver.new(app, :profile => profile)
  end

  Capybara.current_driver = :selenium
end