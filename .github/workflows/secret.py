import os 

source_dir = "./TodayMood/Sources/"
secret_file = "Secrets.swift"
full_path = source_dir + secret_file
client_id = os.getenv('CLIENT_ID')
client_secret = os.getenv('CLIENT_SECRET')

secret_content = "struct Secrets {\n\tstatic let clientID = \""+client_id+"\"\n\tstatic let clientSecret = \""+client_secret+"\"\n}"

f = open(full_path,'w')
f.write(secret_content)
f.close()

print(client_id) 
print("[+] Secrets.swift is Generated !")