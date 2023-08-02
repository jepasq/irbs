# Here is the config/entry file of any irbs project

i = IrbsServer.new
i.listen_port = 20004 # Change current port

# Configure the router
i.route do
  '/' => Application.new

end


i.start

