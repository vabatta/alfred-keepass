# encoding: utf-8
require "openssl"
require "base64"
require "net/http"
require "json"
load "crypt.rb"

# Algorithm to use with the cyphers and keepass server url
algorithm = "AES-256-CBC"
keepass_server = "https://localhost:19455"

# Get a random aes 256-bit key
aes_key = OpenSSL::Cipher.new(algorithm).random_key
# A random iv to use
iv = OpenSSL::Cipher.new(algorithm).random_iv
# Encode stuff
key = b64enc(aes_key)
nonce = b64enc(iv)
verifier = encrypt(nonce, key, iv)

# Make the request
uri = URI(keepass_server)
req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
req.body = {
  RequestType: "associate",
  Nonce: nonce,
  Verifier: verifier,
  Key: key
}.to_json

puts "Accept in MacPass..."
res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  # http.use_ssl = (uri.scheme == "https")
  http.request(req)
end

body = JSON.parse(res.body)
if body["Success"]
  puts "Your KEY NAME: %s" % [body["Id"]]
  puts "Your AES KEY : %s" % [key]
else
  puts "Something went wrong"
  puts body["Error"]
end
