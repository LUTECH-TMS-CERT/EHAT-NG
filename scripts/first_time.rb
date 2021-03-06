require './model/master.rb'
require './helpers/xslt_generation'
require 'openssl'
require 'json'

userx = User.first

# If there are no users, create a first user
if !userx
	puts "No users in the database, creating a first user. \n"

	puts "Please enter username (default: admin):  "
	username = gets.chomp
	username = "admin" if username == ""

	puts "Please enter password (default: random password): "
	password = gets.chomp
	password = rand(36**10).to_s(36) if password == ""

	exists = User.first(:username => username)

	if exists
		puts "That username already exists. Please use reset_pw.rb to reset a password"
	else
		user = User.new
		user.username = username
		user.password = password
		user.type = "Administrator"
		user.auth_type = "Local"
		user.save

		puts "Please use the following login credentials"
		puts "\t \t \t ****  #{username} : #{password} ****"

	end
else
	puts "Skipping username creation (users exist), please use the create_user.rb script to add a user."
end

puts "Would you like to initialize the database with templated findings? (Y/n)"

find_i = gets.chomp
if (find_i == "" or find_i.downcase == "y" or find_i.downcase == "yes")
    puts "Importing Templated Findings template_findings.json..."

    file = File.new('./templates/template_findings.json',"rb")
    json = ""
    while(line_j = file.gets)
        json = json + line_j
    end
    line = JSON.parse(json)

    line.each do |j|
        j["id"] = nil

        finding = TemplateFindings.first(:title => j["title"])

        j["approved"] = true
        f = TemplateFindings.first_or_create(j)
        f.save
    end
else
    puts "Skipping templated finding import. Use the UI to import templated findings."
end

# add the Default templates into the DB
templates = Xslt.first

if !templates
    puts "Adding the Default Security Report Template"
    xslt_file = "./templates/#{rand(36**36).to_s(36)}.xslt"
    docx = "./templates/Security Report.docx"

    xslt = generate_xslt(docx)
    if xslt =~ /Error file DNE/
        return "ERROR!!!!!!"
    end

    # open up a file handle and write the attachment
    File.open(xslt_file, 'wb') {|f| f.write(xslt) }

    # delete the file data from the attachment
    datax = Hash.new
    datax["docx_location"] = "#{docx}"
    datax["xslt_location"] = "#{xslt_file}"
    datax["description"] =  "Security Report"
    datax["report_type"] = "Default Template"
    report = Xslt.new(datax)
    report.save

else
	puts "Skipping XSLT creation, templates exist."
end

# create the SSL cert
puts "Creating self-signed SSL certificate, you should really have a legitimate one."

name = "/C=US/ST=MD/L=MD/O=MD/CN=serpico"
ca   = OpenSSL::X509::Name.parse(name)
key = OpenSSL::PKey::RSA.new(1024)

crt = OpenSSL::X509::Certificate.new
crt.version = 2
crt.serial  = rand(10**10)
crt.subject = ca
crt.issuer = ca
crt.public_key = key.public_key
crt.not_before = Time.now
crt.not_after  = Time.now + 1 * 365 * 24 * 60 * 60 # 1 year

ef = OpenSSL::X509::ExtensionFactory.new
ef.subject_certificate = crt
ef.issuer_certificate = crt
crt.extensions = [
ef.create_extension("basicConstraints","CA:TRUE", true),
ef.create_extension("subjectKeyIdentifier", "hash"),
]
crt.add_extension ef.create_extension("authorityKeyIdentifier",
"keyid:always,issuer:always")
crt.sign key, OpenSSL::Digest::SHA1.new

File.open("./cert.pem", "w") do |f|
  f.write crt.to_pem
end

File.open("./key.pem", "w") do |f|
  f.write key.to_pem
end

# Copying the default configurations over
puts "Copying configuration settings over."
File.open("./config.json", "w") do |f|
	f.write File.open("./config.json.defaults", "r").read
end

