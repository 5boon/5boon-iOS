import os

source_dir = "./TodayMood/Sources/"
secret_file = "Secrets.swift"
full_path = source_dir + secret_file
client_id = os.getenv('CLIENT_ID')
client_secret = os.getenv('CLIENT_SECRET')
user_agent = os.getenv('USER_AGENT')

secret_content = "struct Secrets {\n\tstatic let clientID = \""+client_id+"\"\n\tstatic let clientSecret = \""+client_secret+"\"\n\tstatic let userAgent = \""+user_agent+"\"\n}"

f = open(full_path,'w')
f.write(secret_content)
f.close()

print("[+] Secrets.swift is Generated !")