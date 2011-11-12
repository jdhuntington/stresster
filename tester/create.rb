#!/usr/bin/env ruby

require 'rubygems'
require 'curb'
require 'json'
require 'base64'

url = "http://localhost:3000/widgets.json"

random_crap = Base64.encode64(`cat /dev/urandom | head -n 2`)

field = Curl::PostField.content('widget[data]', random_crap)

response = Curl::Easy.http_post(url, field)

p response.response_code
p response.header_str
p response.body_str
