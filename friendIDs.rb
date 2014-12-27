require 'oauth'                     # for Twitter access
require 'json'                      # read teh Twitter info
require_relative 'tokens'

# build request URL
baseurl 	= "https://api.twitter.com"
id_path 	= "/1.1/friends/ids.json"
cursor		= -1
id_query	= URI.encode_www_form("cursor" => cursor,
							  "screen_name" => "scottpantall",
							  "count" => 100)
id_address	= URI("#{baseurl}#{id_path}?#{id_query}")
id_request = Net::HTTP::Get.new id_address.request_uri

# Set up HTTP.
http             = Net::HTTP.new id_address.host, id_address.port
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
id_request.oauth! http, consumer_key, access_token
http.start
response = http.request id_request

puts id_address

# Parse if the response code is 200
if response.code == '200'
	friends = JSON.parse(response.body)

	listOfIDs = friends["ids"].join(",")
	puts listOfIDs

	lookup_path = "/1.1/users/lookup.json"
	lookup_query = URI.encode_www_form("user_id" => listOfIDs)
	lookup_address = URI("#{baseurl}#{lookup_path}?#{lookup_query}")
	lookup_request = Net::HTTP::Get.new lookup_address.request_uri

	# Set up HTTP.
	http             = Net::HTTP.new lookup_address.host, lookup_address.port
	http.use_ssl     = true
	http.verify_mode = OpenSSL::SSL::VERIFY_PEER

	# Issue the request.
	lookup_request.oauth! http, consumer_key, access_token
	http.start
	response = http.request lookup_request

	puts lookup_address

	if response.code == '200'
		users = JSON.parse(response.body)
		count = 0

		users.each do |account|
			count += 1
			puts "#{count}) #{account["name"]}: #{account["status"]["created_at"]}"
		end
	else
		puts "Expected a response from lookup of 200 but got #{response.code} instead"
  		puts response
  	end

else
  # There was an error issuing the request.
  puts "Expected a response of 200 from IDs but got #{response.code} instead"
  puts response
end