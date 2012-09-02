require 'helper'
require 'capybara'
require 'capybara/dsl'
require 'capybara/webkit'

Capybara.default_selector  = :css
Capybara.default_driver    = :webkit
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
    find('#gift').click

    assert page.has_css? 'div.noty_message'
    assert 'thanks!', page.find('span.noty_text').text
    assert_equal '', page.find('#serial').value
  end

  def test_gift_failure
    serial = '10291021'
    visit '/'

    assert page.has_no_css? 'div.noty_message'
    fill_in 'serial', :with => serial
    find('#gift').click

    assert page.has_css? 'div.noty_message'
    assert 'invalid...', page.find('span.noty_text').text
    assert_equal serial, page.find('#serial').value
  end
end
