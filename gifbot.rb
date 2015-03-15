#ruby

require 'bundler/setup'
#require 'json'
require 'net/http'
require 'sinatra'

SLACK_TOKEN="YOUR_TOKEN"

post "/gif" do
  return 401 unless request["token"] == SLACK_TOKEN
  q = request["text"].sub(request["trigger_word"], "")
  q = URI::encode q
  url = "http://www.reactiongifs.com/?s=#{q}&submit=Search"
  # $stderr.puts "querying giphy: #{url}"
  resp = Net::HTTP.get_response(URI.parse(url))
  body = resp.body
 
  images = body.scan(/src="(?:.*).gif"/i)
  puts "Images found: #{images}"
  if images.empty?
    text = ":cry:"
  else
    image = images[rand(images.size)][5..-1][0..-2]
    text = "<" + image + ">"
  end
  reply = "{ \"username\" : \"#{request["user_name"]}\", \"text\" : \"#{text}\"}"
  return reply
end
