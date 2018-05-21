# encoding: utf-8
load "runner.rb"

keepass_server = "http://localhost:19455"
key_name = "08867FDB-AE60-4361-9425-A1A07A9B5E45"
aes_key = "5xXezHcnq8HbxMCUyPu9g3AiryOscUxWjkrOH8VdzGo="
url = ARGV[0]
# url = "{query}"

puts run(keepass_server, key_name, aes_key, url)
