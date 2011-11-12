#!/usr/bin/env ruby

require 'rubygems'
require 'curb'
require 'json'
require 'base64'
require 'thread'

$semaphore = Mutex.new
$known_ids_lock = Mutex.new
$known_ids = []
threads = []


if ARGV.length != 2
  STDERR.puts "Usage: #{__FILE__} hostname thread_count"
  exit 1
end
base_url = "http://#{ARGV[0]}/widgets.json"
thread_count = ARGV[1].to_i

def ack(key)
  $known_ids_lock.synchronize {
    $known_ids << key
  }
end

def log(response)
  val = if !response
          '~'
        elsif response.total_time < 0.3
          '.'
        elsif response.total_time < 0.85
          '!'
        else
          'X'
        end
  $semaphore.synchronize { STDOUT.print val }
end

thread_count.times do
  t = Thread.new {
    while true
      if rand < 0.6
        if !$known_ids.empty?
          url = "#{base_url}?key=#{$known_ids[rand($known_ids.length)]}"
          begin
            response = Curl::Easy.http_get(url)
          rescue Curl::Err::ConnectionFailedError => e
            response = nil
          end
          log response
        end
      else
        begin
          response = Curl::Easy.http_post(base_url)
          ack JSON.parse(response.body_str)['key']
        rescue
          response = nil
        end
        log response
      end
    end
  }
  threads << t
  $semaphore.synchronize {
    STDERR.puts "Spawned thread."
  }
end

$semaphore.synchronize {
  STDERR.puts "Waiting for work to be done..."
}
threads.each &:join
