source_dir = "./TodayMood/Sources/"
secret_file = "Secrets.swift"
full_path = source_dir + secret_file
secret_content = "struct Secrets {\n\tstatic let clientID = \"\"\n\tstatic let clientSecret = \"\"\n}"

f = open(full_path,'w')
f.write(secret_content)
f.close()

print("[+] Secrets.swift is Generated !")