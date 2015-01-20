require 'twitter'                 # allows connection to twitter
require 'active_support/core_ext' # needed for time
require_relative 'tokens'         # Super secret API token file

# Create connection to Twitter
client = Twitter::REST::Client.new do |config|
  config.consumer_key = MY_CONSUMER_KEY
  config.consumer_secret = MY_CONSUMER_SECRET
  config.access_token = MY_ACCESS_TOKEN
  config.access_token_secret = MY_ACCESS_SECRET
end

# Awesome cool variables
count = 0                 # Number of friends that haven't tweeted in 6 months
oldfriends = []           # Array of old friends
friends = client.friends  # All teh friends

# Loop through friends, display old friends and add them to array
begin
  friends.each do |friend|
    if friend.status.created_at < 6.months.ago
      count += 1
      puts "#{friend.screen_name}: #{friend.status.created_at}"
      oldfriends << friend
    end
  end	

# If too many requests are made, wait until it can make more requests and retry
# Should probably be made into a function
rescue Twitter::Error::TooManyRequests => error
  time = Time.new
  puts "Watchin... and waitin... #{time.inspect}"
  sleep error.rate_limit.reset_in + 1
  retry
end

# Since the retry gets dupicate twitter accounts, make sure there are no duplicates
oldfriends.uniq!

puts "I will unfollow #{count} Twitter accounts"
puts "Listed accounts..."

# Loop through array of oldfriends. Unfollow those that are not in my "Friends" list
begin
  oldfriends.each do |friend|
    client.unfollow(friend) unless client.list_member? client.list(6956771), friend
    puts "#{friend.screen_name} has been unfollowed"
  end

# If too many requests are made, wait until it can make more requests and retry
# Should probably be made into a function	
rescue Twitter::Error::TooManyRequests => error
  time = Time.new
  puts "Watchin... and waitin... #{time.inspect}"
  sleep error.rate_limit.reset_in + 1
  retry
end