require 'oauth'                     # for Twitter access
require 'json'                      # read teh Twitter info
require 'active_support/core_ext'   # For comparing times
require_relative 'tokens'

# Method for finding dormant friends
 def find_old_friends(friends)
  count = 0

 	friends["users"].each do |friend|
    count += 1
    puts "#{count}) #{friend["screen_name"]}: #{friend["status"]["created_at"]}"

    #if Time.parse(friend["status"]["created_at"]) < 1.day.ago
    #  puts "#{friend["screen_name"]}: #{friend["status"]["created_at"]}"
    #end
 	end

  puts friends["next_cursor"]
 end

# Build request URL
baseurl = "https://api.twitter.com"
path    = "/1.1/friends/list.json"
cursor  = -1
query   = URI.encode_www_form("cursor" => cursor,"screen_name" => "scottpantall", "count" => 200)
address = URI("#{baseurl}#{path}?#{query}")
request = Net::HTTP::Get.new address.request_uri

# Set up HTTP.
http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# The ||= operator will only assign these values if
# they are not already set.
consumer_key ||= OAuth::Consumer.new(
    MY_CONSUMER_KEY,
    MY_CONSUMER_SECRET)
access_token = OAuth::Token.new(
    MY_ACCESS_TOKEN,
    MY_ACCESS_SECRET)

# Issue the request.
request.oauth! http, consumer_key, access_token
http.start

while(cursor != 0)  
  response = http.request request

  # Parse if the response code was 200
  if response.code == '200' then
    friends = JSON.parse(response.body)
    if friends
      find_old_friends(friends)
      puts friends["next_cursor"]
      cursor = friends["next_cursor"]
      query   = URI.encode_www_form("cursor" => cursor,"screen_name" => "scottpantall", "count" => 200)
      address = URI("#{baseurl}#{path}?#{query}")
      puts address
      request = Net::HTTP::Get.new address.request_uri

      # Set up HTTP.
      http             = Net::HTTP.new address.host, address.port
      http.use_ssl     = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      # Issue the request.
      request.oauth! http, consumer_key, access_token
      http.start
    else
      puts "Floober!"
      cursor = 0
    end
  
  else
  	# There was an error issuing the request.
      puts "Expected a response of 200 but got #{response.code} instead"
      puts response
  end
end