require 'zip'
require 'optparse'

options = {}
optionparser = OptionParser.new do |opts|
    opts.banner = "This will backup your current database and screenshots!\n\nUsage: #{$0} [options] \n\n"
    opts.on("-d", "--directory", "Backup directory") do |d|
        options[:directory] = d
    end
end

begin
    optionparser.parse!
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
    puts "\n\033[33mERROR: #{$!.to_s}\033[0m\n\n"
    puts optionparser.help
    exit
end

if options.empty? || options.length > 2
    puts optionparser.help
    exit 1
end

if options[:directory]
	bdate  = Time.now()

	db_filename = "./tmp/master-" + (bdate.strftime("%Y%m%d%H%M%S") +".bak")
	attachments_filename = "./tmp/Attachments" + "-" + (bdate.strftime("%Y%m%d%H%M%S") +".zip")
	templates_filename = "./tmp/Templates" + "-" + (bdate.strftime("%Y%m%d%H%M%S") +".zip")
	global_filename = "./tmp/EHAT-NG_backup_" + (bdate.strftime("%Y%m%d%H%M%S") +".zip")

	FileUtils::copy_file("./db/master.db", db_filename)

	Zip::File.open(attachments_filename, Zip::File::CREATE) do |zipfile|
		Dir["./attachments/*" ].each do | name|
			zipfile.add(name.split("/").last,name)
		end
	end
        
	Zip::File.open(templates_filename, Zip::File::CREATE) do |zipfile|
                Dir["./templates/*" ].each do | name|
                        zipfile.add(name.split("/").last,name)
                end
        end

	Zip::File.open(global_filename, Zip::File::CREATE) do |zipfile|
		zipfile.add(db_filename.split("/").last,db_filename)
		zipfile.add(attachments_filename.split("/").last,attachments_filename)
		zipfile.add(templates_filename.split("/").last,templates_filename)
	end


	destination_path = ARGV[0]

	FileUtils::copy_file(global_filename, ARGV[0] + global_filename.split("/").last )
end
