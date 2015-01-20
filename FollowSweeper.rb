require 'twitter'
require 'json'
require 'active_support/core_ext'
require_relative 'tokens'

client = Twitter::REST::Client.new do |config|
  config.consumer_key = MY_CONSUMER_KEY
  config.consumer_secret = MY_CONSUMER_SECRET
  config.access_token = MY_ACCESS_TOKEN
  config.access_token_secret = MY_ACCESS_SECRET
end


count = 0
oldfriends = []
friends = client.friends


begin
  friends.each do |friend|
    if friend.status.created_at < 6.months.ago
      count += 1
      puts "#{friend.screen_name}: #{friend.status.created_at}"
      oldfriends << friend
    end
  end	
rescue Twitter::Error::TooManyRequests => error
  time = Time.new
  puts "Watchin... and waitin... #{time.inspect}"
  sleep error.rate_limit.reset_in + 1
  retry
end
oldfriends.uniq!

puts "I will unfollow #{count} Twitter accounts"
puts "Listed accounts..."

begin
  oldfriends.each do |friend|
    client.unfollow(friend) unless client.list_member? client.list(6956771), friend
    puts "#{friend.screen_name} has been unfollowed"
  end	
rescue Twitter::Error::TooManyRequests => error
  time = Time.new
  puts "Watchin... and waitin... #{time.inspect}"
  sleep error.rate_limit.reset_in + 1
  retry
end