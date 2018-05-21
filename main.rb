# encoding: utf-8
load "runner.rb"

keepass_server = "http://localhost:19455"
key_name = "<YOUR KEY NAME>"
aes_key = "<YOUR AES KEY>"
format = "%s %s"
url = ARGV[0]
# url = "{query}"

puts run(keepass_server, key_name, aes_key, format, url)
