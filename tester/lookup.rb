#!/usr/bin/env ruby

require 'rubygems'
require 'curb'
require 'json'

url = "http://localhost:3000/widgets.json?key=#{ARGV.first}"

response = Curl::Easy.http_get(url)

p response.response_code
