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


FILENAME = "oldfriends.txt" # Name of fiile to store old friends
friends = client.friends    # All teh friends
count = 0                   # Count number of accounts read
oldcount = 0                # Count numer of old friends
oldfriends = []             # Array to hold screen_names

# ONly create a new list of friends to unfollow 
# if a list does not already exist

if File.file?(FILENAME)
  File.open(FILENAME, "r").each_line do |line| 
    oldfriends << line 
    oldcount += 1
  end
else
  outFile = File.new(FILENAME, "w")
    
  puts "Searching your friends list for friends who have not updated in over 6 months. This may take a while..."

  # Loop through friends, display old friends and add them to array
  friends.each do |friend|
    count += 1
    if(count < 300)
      if friend.status.created_at < 6.months.ago
        oldcount += 1
        puts "#{friend.screen_name}: #{friend.status.created_at}"
        outFile.puts "#{friend.screen_name}"
      end
    else
      time = Time.new
      puts "Watchin... and waitin... #{time.inspect}"
      sleep 901
      count = 0
    end
  end 
  outFile.close()
end

puts "I can unfollow #{oldcount} Twitter accounts"

=begin
puts "Unfollowing friends who haven’t updated in over 6 months…"
count = 0


# Loop through array of oldfriends. Unfollow those that are not in my "Friends" list
begin
  oldfriends.each do |friend|
    count += 1
    puts "#{count}"
    client.unfollow(friend)
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
=end