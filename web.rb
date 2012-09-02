# -*- coding: utf-8 -*-

require 'sinatra'
require 'haml'

configure :production, :development do
  require 'redis'
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

set :haml, :format => :html5

get '/', :agent => /iPhone/ do
  haml :mobile
end

get '/' do
  @url = request.host + (request.port == 80 ? '' : ":#{request.port.to_s}")
  @count = REDIS.scard('serial')
  haml :index
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
    %meta(charset='UTF-8')
    %link(rel="stylesheet" type="text/css" href="main.css")
  %body
    %div#wrapper
      %p
        %span#cmd $ curl -d 'serial=/\d{16}/' #{@url}
      %p
        %span#stock Stock #{@count}
      %p
        %a#help(href='https://github.com/gongo/gpkure')Help

@@ mobile
!!!
%html
  %head
    %title Georgia Point Kure
    %meta(charset='UTF-8')
    %meta(name='viewport' content='width=device-width, initial-scale=1')
    %link(rel="stylesheet" type="text/css" href="mobile.css")
    %link(rel='stylesheet' media='screen' href='http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.css')
    %script(src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js")
    %script(src='http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.js')
    %script(src="noty/jquery.noty.js")
    %script(src="noty/layouts/bottom.js")
    %script(src="noty/themes/default.js")
    %script(src="mobile.js")
  %body
    %div#wrapper{:style => "margin-top: 20px;"}
      Please input 16 digits.
      %p
        %input#serial{:type => "tel", :name => "serial", :maxlength => "16", :"data-mini" => "true"}/
      %p
        %button#gift{:type => "button"}
          "Gift"

