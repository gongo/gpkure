# -*- coding: utf-8 -*-

require 'sinatra'
require 'haml'

configure do
  require 'redis'
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/' do
  @url = request.host + (request.port == 80 ? '' : ":#{request.port.to_s}")
  @count = REDIS.scard('serial')
  haml :index, :format => :html5
end

post '/' do
  serial = params[:serial]
  if /^(\d{16})$/ =~ serial
    REDIS.sadd('serial', serial)
    "ok"
  end
end

__END__

@@ index
!!!
%html
  %head
    %title Georgia Point Kure
    :css
      #wrapper {
          width: 800px;
          height: 200px;
          margin: 0 auto;
          position: absolute;
          top: 50%;
          left: 50%;
          margin: -100px 0 0 -400px;
          text-align: center;
      }

      #wrapper > span {
          font-size: 24px;
          font-weight: bold;
      }
  %body
    %div#wrapper
      <span>$ curl -d 'serial=/\d{16}/' #{@url}</span>
