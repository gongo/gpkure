# -*- coding: utf-8 -*-

require 'helper'
require 'rack/test'

class GpkureTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    REDIS.flushall
  end

  def app
    Sinatra::Application
  end

  def test_get
    get '/'
    assert last_response.ok?
    assert last_response.body.include? '$ curl -d \'serial=/\\d{16}/\' example.org'
  end

  def test_get_with_port_not_80
    get '/', nil, { 'HTTP_HOST' => 'localhost', 'SERVER_PORT' => 8080 }
    assert last_response.ok?
    assert last_response.body.include? '$ curl -d \'serial=/\\d{16}/\' localhost:8080'
  end

  def test_get_with_mobile_user_agent
    get '/', nil, { 'HTTP_USER_AGENT' => USER_AGENT_IPHONE4 }
    assert last_response.ok?
    assert !(last_response.body.include? '$ curl -d \'serial=/\\d{16}/\' example.org')
    assert last_response.body.include?('<button')
  end

  def test_post
    assert_equal 'ok', post_body('serial' => '1111111111111111')
    assert_equal 'ok', post_body('serial' => '2222222222222222')
    assert_equal 'ok', post_body('serial' => '1111111111111111')
    assert_equal 'ok', post_body('serial' => '3333333333333333')

    assert_equal 3, REDIS.scard('serial')
  end

  def test_post_with_invalid_params
    # no params
    assert_equal 'no', post_body

    # not 16 digits
    assert_equal 'no', post_body('serial' => '3')
    assert_equal 'no', post_body('serial' => 'aaaaaaaaaaaaaaaa')
    assert_equal 'no', post_body('serial' => '111111111111111')
    assert_equal 'no', post_body('serial' => '11111111111111111')
    assert_equal 'no', post_body('serial' => 'あいうえお')

    # multi param
    assert_equal 'no', post_body('serial' => ['1111111111111111',
                                              '2222222222222222',
                                              '3333333333333333'])

    assert_equal 0, REDIS.scard('serial')
  end

  def post_body(params = {})
    post '/', params
    assert_equal 200, last_response.status
    last_response.body
  end
end
