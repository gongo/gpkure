require 'web'
require 'test/unit'

configure :test do
  require 'mock_redis'
  REDIS = MockRedis.new
end

USER_AGENT_IPHONE4 = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_4 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8K2 Safari/6533.18.5'
