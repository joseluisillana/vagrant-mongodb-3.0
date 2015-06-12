name             "mongodb3-debs"
maintainer       "Jose Luis Illana Ruiz"
maintainer_email "joseluisillana@gmail.com"
license          "Apache 2.0"
description      "Installs MongoDB 3.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.0"

%w{ ubuntu debian }.each do |os|
  supports os
end
