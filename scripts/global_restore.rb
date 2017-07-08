require 'zip'
require 'optparse'

Zip.on_exists_proc = true

options = {}
optionparser = OptionParser.new do |opts|
    opts.banner = "!!! WARNING !!!\n\n This will destroy your current database and templates with same name!\n\nUsage: #{$0} [options] \n\n"
    opts.on("-f", "--file", "Restore backup from file") do |f|
        options[:file] = f
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

if options[:file] # restore from file
	Zip::File.open(ARGV[0]) do |zip_file|
	  # Extract db file
	  db_backup = zip_file.glob('*.bak').first
	  db_backup.extract("./db/master.db")

	  attachments_zip = zip_file.glob('Attachments*').first
	  attachments_zip.extract("./tmp/"+attachments_zip.name)
	  
	  templates_zip = zip_file.glob('Templates*').first
	  templates_zip.extract("./tmp/"+templates_zip.name)

	  Zip::File.open("./tmp/"+attachments_zip.name) do |zip_file2|
	  # Handle attachments one by one
		  zip_file2.each do |entry|
		  	entry.extract("./attachments/"+entry.name)
		  end
	  end


          Zip::File.open("./tmp/"+templates_zip.name) do |zip_file3|
          # Handle templates one by one
                  zip_file3.each do |entry|
                        entry.extract("./templates/"+entry.name)
                  end
          end

	end
end
