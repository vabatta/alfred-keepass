# encoding: utf-8
require "openssl"
require "base64"
require "net/http"
require "json"
load "crypt.rb"
load "utilities.rb"

def run(keepass_server, key_name, aes_key, format, query)
  # Get random IV
  iv = OpenSSL::Cipher.new("AES-256-CBC").random_iv
  # Encode stuff
  nonce = b64enc(iv)
  veri = encrypt(nonce, aes_key, iv)
  url = encrypt(query, aes_key, iv)

  # Make request
  uri = URI(keepass_server)
  req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
  req.body = {
    RequestType: "get-logins",
    # SortSelection: "true",
    Id: key_name,
    Nonce: nonce,
    Verifier: veri,
    Url: url,
  }.to_json

  res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(req)
  end

  # Parse and save decoding info
  body = JSON.parse(res.body)
  resp_nonce = body["Nonce"]

  # Iterates entries if any
  entries = body["Entries"]
  unless entries.nil?
    alfred_formatter =  AlfredFormatter.new(format)

    # Decode and add them
    entries.each do |entry|
      title = entry["Name"]
      username = entry["Login"]
      password = entry["Password"]

      title_plain = decrypt(title, aes_key, resp_nonce)
      username_plain = decrypt(username, aes_key, resp_nonce)
      password_plain = decrypt(password, aes_key, resp_nonce)

      kp = KeepassItem.new(title_plain, username_plain, password_plain)
      alfred_formatter.add_kp(kp)
    end

    return alfred_formatter.to_string
  end

  return nil
end