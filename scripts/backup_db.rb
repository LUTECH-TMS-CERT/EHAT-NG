require 'zip'

path = "/tmp/"

bdate  = Time.now()
filename = path+"master" + "-" + (bdate.strftime("%Y%m%d%H%M%S") +".bak")

FileUtils::copy_file("./db/master.db", filename)

