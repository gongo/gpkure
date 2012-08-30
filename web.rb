# -*- coding: utf-8 -*-

require 'sinatra'
require 'haml'

configure :production, :development do
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

  if validate(serial)
    REDIS.sadd('serial', serial)
    "ok"
  else
    "no"
  end
end

def validate(serial)
  serial.instance_of?(String) and /^(\d{16})$/ =~ serial
end

__END__

@@ index
!!!
%html
  %head
    %title Georgia Point Kure
    :css
      * {
          background-color: #ffffff;
          color: #000000;
      }

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

      span#cmd {
          font-size: 24px;
      }

      a#help {
          text-decoration: underline;
      }

  %body
    %div#wrapper
      %p
        %span#cmd$ curl -d 'serial=/\d{16}/' #{@url}
      %p
        %a#help(href='https://github.com/gongo/gpkure')Help
