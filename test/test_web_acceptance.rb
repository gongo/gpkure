require 'capybara'
require 'capybara/dsl'
require 'capybara/webkit'

Capybara.default_driver = :webkit
Capybara.javascript_driver = :webkit

class GpkureAcceptanceTest < Test::Unit::TestCase
  include Capybara::DSL

  def setup
    Capybara.app = Sinatra::Application.new
    page.driver.header('user-agent', USER_AGENT_IPHONE4)
  end

  def test_gift_success
    visit '/'

    assert page.has_no_css? 'div.noty_message'
    fill_in 'serial', :with => '1234567812345678'
    find(:css, '#gift').click

    assert page.has_css? 'div.noty_message'
    assert 'thanks!', page.find(:css, 'span.noty_text').text
  end

  def test_gift_success
    visit '/'

    assert page.has_no_css? 'div.noty_message'
    fill_in 'serial', :with => '10291021'
    find(:css, '#gift').click

    assert page.has_css? 'div.noty_message'
    assert 'invalid...', page.find(:css, 'span.noty_text').text
  end
end
